#!/bin/bash
# Hook: Stop — Consolidated checks (discovery cadence + SLA escalation + strategy review)
# Autor: Piperun Product OS
# Replaces: post-analysis-reminder.sh (removed — noise without value),
#           discovery-cadence-check.sh, sla-escalation-check.sh, strategy-review-reminder.sh

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
REMINDERS=""

# ============================================================================
# 1. Discovery cadence check (>=1 touchpoint/week)
# ============================================================================
DISCOVERY_DIR="$PROJECT_DIR/reports/discovery"
if [ -d "$DISCOVERY_DIR" ]; then
    # Get start of current week (Monday)
    WEEK_START=$(date -v-monday +%Y-%m-%d 2>/dev/null || date -d "last monday" +%Y-%m-%d 2>/dev/null || "")
    if [ -z "$WEEK_START" ]; then
        WEEK_START=$(date -v-7d +%Y-%m-%d 2>/dev/null || date -d "7 days ago" +%Y-%m-%d 2>/dev/null || "")
    fi

    TOUCHPOINT_COUNT=0
    if [ -n "$WEEK_START" ]; then
        for file in "$DISCOVERY_DIR"/touchpoint-*.md; do
            [ -f "$file" ] || continue
            FILE_DATE=$(echo "$file" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1)
            if [ -n "$FILE_DATE" ] && [ "$FILE_DATE" \> "$WEEK_START" -o "$FILE_DATE" = "$WEEK_START" ]; then
                TOUCHPOINT_COUNT=$((TOUCHPOINT_COUNT + 1))
            fi
        done
    fi

    if [ "$TOUCHPOINT_COUNT" -eq 0 ]; then
        DAY_OF_WEEK=$(date +%u 2>/dev/null || echo "0")
        if [ "$DAY_OF_WEEK" -ge 5 ]; then
            REMINDERS="${REMINDERS}DISCOVERY: Nenhum touchpoint esta semana (meta: >=1/semana). Use /discovery-touchpoint-log. "
        else
            REMINDERS="${REMINDERS}Discovery: nenhum touchpoint esta semana ainda (meta: >=1/semana). "
        fi
    fi
fi

# ============================================================================
# 2. SLA escalation check for P0/P1 bugs (no network calls)
# ============================================================================
INDEX_FILE="$PROJECT_DIR/reports/backlog/opportunity-index.json"
if [ -f "$INDEX_FILE" ] && command -v jq &> /dev/null; then
    NOW=$(date +%s)

    # Process P0 bugs
    jq -r '.opportunities[]? | select(.type == "bug" and .severity == "P0" and (.status != "promoted" and .status != "rejected" and .status != "archived")) | .id + "|" + .title + "|" + (.created // "")' "$INDEX_FILE" 2>/dev/null | while IFS='|' read -r BUG_ID BUG_TITLE BUG_CREATED; do
        [ -z "$BUG_CREATED" ] || [ "$BUG_CREATED" = "null" ] && continue
        # Parse ISO 8601 with time component if available (fixes datetime bug)
        CREATED_TS=0
        if echo "$BUG_CREATED" | grep -qE 'T[0-9]{2}:[0-9]{2}'; then
            # Has time component: YYYY-MM-DDTHH:MM:SS
            CREATED_TS=$(date -j -f "%Y-%m-%dT%H:%M:%S" "$BUG_CREATED" +%s 2>/dev/null || date -d "$BUG_CREATED" +%s 2>/dev/null || echo 0)
        else
            # Date only fallback: YYYY-MM-DD
            CREATED_TS=$(date -j -f "%Y-%m-%d" "$BUG_CREATED" +%s 2>/dev/null || date -d "$BUG_CREATED" +%s 2>/dev/null || echo 0)
        fi
        if [ "$CREATED_TS" -gt 0 ]; then
            ELAPSED=$(( (NOW - CREATED_TS) / 60 ))
            if [ "$ELAPSED" -gt 20 ]; then
                echo "P0_ALERT:ALERTA P0: ${BUG_ID} — ${BUG_TITLE}. ${ELAPSED}min decorridos. SLA: resposta 30min, correção 4h."
            fi
        fi
    done | while read -r line; do
        if echo "$line" | grep -q "^P0_ALERT:"; then
            REMINDERS="${REMINDERS}$(echo "$line" | sed 's/^P0_ALERT://') "
        fi
    done

    # Process P1 bugs
    jq -r '.opportunities[]? | select(.type == "bug" and .severity == "P1" and (.status != "promoted" and .status != "rejected" and .status != "archived")) | .id + "|" + .title + "|" + (.created // "")' "$INDEX_FILE" 2>/dev/null | while IFS='|' read -r BUG_ID BUG_TITLE BUG_CREATED; do
        [ -z "$BUG_CREATED" ] || [ "$BUG_CREATED" = "null" ] && continue
        CREATED_TS=0
        if echo "$BUG_CREATED" | grep -qE 'T[0-9]{2}:[0-9]{2}'; then
            CREATED_TS=$(date -j -f "%Y-%m-%dT%H:%M:%S" "$BUG_CREATED" +%s 2>/dev/null || date -d "$BUG_CREATED" +%s 2>/dev/null || echo 0)
        else
            CREATED_TS=$(date -j -f "%Y-%m-%d" "$BUG_CREATED" +%s 2>/dev/null || date -d "$BUG_CREATED" +%s 2>/dev/null || echo 0)
        fi
        if [ "$CREATED_TS" -gt 0 ]; then
            ELAPSED=$(( (NOW - CREATED_TS) / 60 ))
            if [ "$ELAPSED" -gt 90 ]; then
                echo "P1_ALERT:ALERTA P1: ${BUG_ID} — ${BUG_TITLE}. ${ELAPSED}min decorridos. SLA: resposta 2h, correção 24h."
            fi
        fi
    done | while read -r line; do
        if echo "$line" | grep -q "^P1_ALERT:"; then
            REMINDERS="${REMINDERS}$(echo "$line" | sed 's/^P1_ALERT://') "
        fi
    done
fi

# ============================================================================
# 3. Strategy review cadence checks (Phases 4-8) — all via file age, no python3
# ============================================================================
STRATEGY_DIR="$PROJECT_DIR/reports/strategy"
if [ -d "$STRATEGY_DIR" ]; then
    NOW_S=$(date +%s)

    # Helper: age in days of the newest file matching a glob
    newest_age() {
        local dir="$1" pattern="$2" newest=999
        if [ -d "$dir" ]; then
            for f in "$dir"/$pattern; do
                [ -f "$f" ] || continue
                local mtime
                mtime=$(stat -c %Y "$f" 2>/dev/null || stat -f %m "$f" 2>/dev/null || echo 0)
                local age=$(( (NOW_S - mtime) / 86400 ))
                [ "$age" -lt "$newest" ] && newest=$age
            done
        fi
        echo $newest
    }

    # OKR check-in (>30 days)
    OKR_AGE=$(newest_age "$STRATEGY_DIR/okrs" "okrs-*.md")
    [ "$OKR_AGE" -gt 30 ] && [ "$OKR_AGE" -lt 999 ] && REMINDERS="${REMINDERS}OKR check-in atrasado (${OKR_AGE}d, meta: mensal). Use /okr-manager. "

    # OST review (>30 days)
    if [ -f "$STRATEGY_DIR/ost/ost-index.json" ]; then
        OST_MTIME=$(stat -c %Y "$STRATEGY_DIR/ost/ost-index.json" 2>/dev/null || stat -f %m "$STRATEGY_DIR/ost/ost-index.json" 2>/dev/null || echo 0)
        OST_AGE=$(( (NOW_S - OST_MTIME) / 86400 ))
        [ "$OST_AGE" -gt 30 ] && REMINDERS="${REMINDERS}OST review atrasado (${OST_AGE}d, meta: mensal). Use /ost-builder. "
    fi

    # Roadmap review (>14 days)
    if [ -f "$STRATEGY_DIR/roadmap/roadmap-current.json" ]; then
        RM_MTIME=$(stat -c %Y "$STRATEGY_DIR/roadmap/roadmap-current.json" 2>/dev/null || stat -f %m "$STRATEGY_DIR/roadmap/roadmap-current.json" 2>/dev/null || echo 0)
        RM_AGE=$(( (NOW_S - RM_MTIME) / 86400 ))
        [ "$RM_AGE" -gt 14 ] && REMINDERS="${REMINDERS}Roadmap review atrasado (${RM_AGE}d, meta: quinzenal). Use /roadmap-planner. "
    fi

    # Ideation (>7 days)
    if [ -f "$STRATEGY_DIR/ideation/ideation-index.json" ]; then
        ID_MTIME=$(stat -c %Y "$STRATEGY_DIR/ideation/ideation-index.json" 2>/dev/null || stat -f %m "$STRATEGY_DIR/ideation/ideation-index.json" 2>/dev/null || echo 0)
        ID_AGE=$(( (NOW_S - ID_MTIME) / 86400 ))
        [ "$ID_AGE" -gt 7 ] && REMINDERS="${REMINDERS}Ideação parada (${ID_AGE}d, meta: semanal). Use /ideation-log. "
    fi

    # Bet tests active >14 days (via jq instead of python3)
    if [ -f "$STRATEGY_DIR/validation/validation-index.json" ] && command -v jq &> /dev/null; then
        STALE_BETS=$(jq -r '.bets[]? | select(.status == "active") | .file // empty' "$STRATEGY_DIR/validation/validation-index.json" 2>/dev/null)
        STALE_LIST=""
        for BET_FILE in $STALE_BETS; do
            FULL_PATH="$STRATEGY_DIR/validation/$BET_FILE"
            if [ -f "$FULL_PATH" ]; then
                BET_MTIME=$(stat -c %Y "$FULL_PATH" 2>/dev/null || stat -f %m "$FULL_PATH" 2>/dev/null || echo 0)
                BET_AGE=$(( (NOW_S - BET_MTIME) / 86400 ))
                if [ "$BET_AGE" -gt 14 ]; then
                    BET_ID=$(echo "$BET_FILE" | grep -oE 'BET-[0-9]{4}-[0-9]{3}' || echo "$BET_FILE")
                    STALE_LIST="${STALE_LIST}${BET_ID} (${BET_AGE}d), "
                fi
            fi
        done
        [ -n "$STALE_LIST" ] && REMINDERS="${REMINDERS}Bet tests ativos >14d: ${STALE_LIST%%, }. Use /bet-test-manager. "
    fi

    # Conception docs stalled (via jq instead of python3)
    if [ -f "$STRATEGY_DIR/conception/conception-index.json" ] && command -v jq &> /dev/null; then
        CONCEPTION_ALERTS=""
        while IFS='|' read -r DOC_STATUS DOC_FILE DOC_ID; do
            [ -z "$DOC_FILE" ] && continue
            FULL_PATH="$STRATEGY_DIR/conception/$DOC_FILE"
            [ -f "$FULL_PATH" ] || continue
            DOC_MTIME=$(stat -c %Y "$FULL_PATH" 2>/dev/null || stat -f %m "$FULL_PATH" 2>/dev/null || echo 0)
            DOC_AGE=$(( (NOW_S - DOC_MTIME) / 86400 ))
            case "$DOC_STATUS" in
                draft) [ "$DOC_AGE" -gt 7 ] && CONCEPTION_ALERTS="${CONCEPTION_ALERTS}${DOC_ID} draft ${DOC_AGE}d, " ;;
                trio-review) [ "$DOC_AGE" -gt 14 ] && CONCEPTION_ALERTS="${CONCEPTION_ALERTS}${DOC_ID} trio-review ${DOC_AGE}d, " ;;
                ready) [ "$DOC_AGE" -gt 7 ] && CONCEPTION_ALERTS="${CONCEPTION_ALERTS}${DOC_ID} ready ${DOC_AGE}d, " ;;
            esac
        done < <(jq -r '.docs[]? | select(.status == "draft" or .status == "trio-review" or .status == "ready") | .status + "|" + (.file // "") + "|" + (.id // "?")' "$STRATEGY_DIR/conception/conception-index.json" 2>/dev/null)
        [ -n "$CONCEPTION_ALERTS" ] && REMINDERS="${REMINDERS}Docs concepção parados: ${CONCEPTION_ALERTS%%, }. Use /conception-manager. "
    fi

    # Sprint review (>14 days)
    SPRINT_AGE=$(newest_age "$STRATEGY_DIR/delivery/sprints" "sprint-review-*.md")
    [ "$SPRINT_AGE" -gt 14 ] && [ "$SPRINT_AGE" -lt 999 ] && REMINDERS="${REMINDERS}Sprint review atrasado (${SPRINT_AGE}d). Use /delivery-tracker sprint review. "

    # Launch reviews D+30/D+90 (via jq instead of python3)
    if [ -f "$STRATEGY_DIR/delivery/delivery-index.json" ] && command -v jq &> /dev/null; then
        LAUNCH_ALERTS=""
        while IFS='|' read -r LID LSTATUS LDATE; do
            [ -z "$LDATE" ] && continue
            LD_TS=$(date -j -f "%Y-%m-%d" "$LDATE" +%s 2>/dev/null || date -d "$LDATE" +%s 2>/dev/null || echo 0)
            [ "$LD_TS" -eq 0 ] && continue
            DAYS_SINCE=$(( (NOW_S - LD_TS) / 86400 ))
            case "$LSTATUS" in
                launched|monitoring)
                    [ "$DAYS_SINCE" -ge 30 ] && LAUNCH_ALERTS="${LAUNCH_ALERTS}${LID}: D+30 pendente (${DAYS_SINCE}d), "
                    ;;
            esac
            case "$LSTATUS" in
                monitoring|reviewing-d30)
                    [ "$DAYS_SINCE" -ge 90 ] && LAUNCH_ALERTS="${LAUNCH_ALERTS}${LID}: D+90 pendente (${DAYS_SINCE}d), "
                    ;;
            esac
        done < <(jq -r '.launches[]? | select(.status == "launched" or .status == "monitoring" or .status == "reviewing-d30") | .id + "|" + .status + "|" + (.launchedDate // .launched_date // "")' "$STRATEGY_DIR/delivery/delivery-index.json" 2>/dev/null)
        [ -n "$LAUNCH_ALERTS" ] && REMINDERS="${REMINDERS}Reviews pendentes: ${LAUNCH_ALERTS%%, }. Use /gtm-feedback-loop. "
    fi

    # Changelog cadence
    CLOG_INT_AGE=$(newest_age "$STRATEGY_DIR/delivery/changelogs" "changelog-internal-*.md")
    [ "$CLOG_INT_AGE" -gt 7 ] && [ "$CLOG_INT_AGE" -lt 999 ] && REMINDERS="${REMINDERS}Changelog interno atrasado (${CLOG_INT_AGE}d, meta: semanal). "

    CLOG_EXT_AGE=$(newest_age "$STRATEGY_DIR/delivery/changelogs" "changelog-external-*.md")
    [ "$CLOG_EXT_AGE" -gt 30 ] && [ "$CLOG_EXT_AGE" -lt 999 ] && REMINDERS="${REMINDERS}Changelog externo atrasado (${CLOG_EXT_AGE}d, meta: mensal). "
fi

# ============================================================================
# Emit consolidated output
# ============================================================================
if [ -n "$REMINDERS" ]; then
    cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "Stop",
    "additionalContext": "VERIFICAÇÕES: ${REMINDERS}"
  }
}
EOF
fi

exit 0
