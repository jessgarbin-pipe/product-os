#!/bin/bash
# Hook: PreToolUse (Write|Edit) — Consolidated validator for all file types
# Autor: Piperun Product OS
# Replaces: validate-bug-severity.sh, validate-discovery-output.sh,
#           validate-backlog-entry.sh, validate-okr-entry.sh, validate-bet-test.sh,
#           validate-conception-doc.sh, validate-launch-doc.sh

# Read stdin once, extract file_path with jq
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)
[ -z "$FILE_PATH" ] && exit 0

# Helper: extract content from Write or Edit tool input
get_content() {
    echo "$INPUT" | jq -r '.tool_input.content // .tool_input.new_string // empty' 2>/dev/null
}

# Helper: emit warning JSON
emit_warning() {
    local label="$1"
    local warnings="$2"
    cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext": "${label}: ${warnings}"
  }
}
EOF
}

# Route by file path
case "$FILE_PATH" in

    # === Bug/Issue severity check ===
    *bug*|*issue*|*incident*|*ticket*)
        CONTENT=$(get_content)
        [ -z "$CONTENT" ] && exit 0
        if echo "$CONTENT" | grep -qi "severidade\|severity\|prioridade\|priority"; then
            if ! echo "$CONTENT" | grep -qE "P[0-3]|p[0-3]"; then
                emit_warning "VALIDAÇÃO BUG" "Arquivo menciona severidade mas não usa padrão P0-P3. Ver Bug SLAs no CLAUDE.md."
            fi
        fi
        ;;

    # === Discovery touchpoint validation (4 required fields) ===
    *reports/discovery/touchpoint*)
        CONTENT=$(get_content)
        [ -z "$CONTENT" ] && exit 0
        W=""
        echo "$CONTENT" | grep -qi "comportamento observado\|comportamento.observado\|## Comportamento" || W="${W}Campo 'Comportamento Observado' ausente. "
        echo "$CONTENT" | grep -qi "dores identificadas\|dores.identificadas\|## Dores" || W="${W}Campo 'Dores Identificadas' ausente. "
        echo "$CONTENT" | grep -qi "oportunidades\|## Oportunidades" || W="${W}Campo 'Oportunidades' ausente. "
        echo "$CONTENT" | grep -qi "evidência\|evidencia\|## Evidência\|## Evidencia" || W="${W}Campo 'Evidência' ausente. "
        # Check for opinion in behavior section
        BEHAVIOR=$(echo "$CONTENT" | sed -n '/[Cc]omportamento [Oo]bservado/,/^##/p' 2>/dev/null)
        if [ -n "$BEHAVIOR" ]; then
            if echo "$BEHAVIOR" | grep -qi "ele acha\|ela acha\|o cliente acha\|disse que gostaria\|disse que quer\|gostaria de\|prefere que\|acredita que"; then
                W="${W}Seção 'Comportamento Observado' contém opiniões — registre ações concretas. "
            fi
        fi
        [ -n "$W" ] && emit_warning "VALIDAÇÃO TOUCHPOINT" "$W"
        ;;

    # === Opportunity Backlog entry validation ===
    *reports/backlog/opportunities/*)
        CONTENT=$(get_content)
        [ -z "$CONTENT" ] && exit 0
        W=""
        echo "$CONTENT" | grep -qi "^id:" || W="${W}Campo 'id' ausente. "
        echo "$CONTENT" | grep -qi "^title:" || W="${W}Campo 'title' ausente. "
        if echo "$CONTENT" | grep -qi "^type:"; then
            TYPE_VALUE=$(echo "$CONTENT" | grep -i "^type:" | head -1 | sed 's/^type:[[:space:]]*//' | tr -d '"' | tr -d "'" | tr '[:upper:]' '[:lower:]')
            case "$TYPE_VALUE" in
                bug|tech-debt|feature|improvement) ;;
                *) W="${W}type deve ser: bug|tech-debt|feature|improvement (encontrado: '${TYPE_VALUE}'). " ;;
            esac
        else
            W="${W}Campo 'type' ausente. "
        fi
        echo "$CONTENT" | grep -qi "^status:" || W="${W}Campo 'status' ausente. "
        if echo "$CONTENT" | grep -qi "^source:"; then
            SRC=$(echo "$CONTENT" | grep -i "^source:" | head -1 | sed 's/^source:[[:space:]]*//' | tr -d '"' | tr -d "'")
            case "$SRC" in
                customer-suggestion|internal-sales|internal-cs|internal-implantation|pm-discovery|bug-report|tech-debt|monitoring-insight) ;;
                *) W="${W}source inválida: '${SRC}'. " ;;
            esac
        else
            W="${W}Campo 'source' ausente. "
        fi
        echo "$CONTENT" | grep -qi "^module:" || W="${W}Campo 'module' ausente. "
        echo "$CONTENT" | grep -qi "^created:" || W="${W}Campo 'created' ausente. "
        # Bugs require severity
        if echo "$CONTENT" | grep -qi "^type:.*bug"; then
            echo "$CONTENT" | grep -qE "^severity:.*P[0-3]" || W="${W}Bug requer severity P0-P3. "
        fi
        [ -n "$W" ] && emit_warning "VALIDAÇÃO BACKLOG" "$W"
        ;;

    # === OKR validation ===
    *reports/strategy/okrs/*.md)
        CONTENT=$(get_content)
        [ -z "$CONTENT" ] && exit 0
        W=""
        echo "$CONTENT" | grep -qE 'quarter:\s*"?[0-9]{4}-Q[1-4]"?' || W="${W}Campo 'quarter' ausente/inválido (YYYY-QN). "
        echo "$CONTENT" | grep -qE 'status:\s*"?(draft|active|review|closed)"?' || W="${W}Campo 'status' ausente/inválido. "
        echo "$CONTENT" | grep -qE 'created:\s*"?[0-9]{4}-[0-9]{2}-[0-9]{2}"?' || W="${W}Campo 'created' ausente/inválido. "
        echo "$CONTENT" | grep -qiE '##\s*Objetivo\s+[0-9]' || W="${W}Nenhum '## Objetivo N' encontrado. "
        echo "$CONTENT" | grep -qiE '###\s*KR\s+[0-9]' || W="${W}Nenhum KR encontrado. "
        [ -n "$W" ] && emit_warning "VALIDAÇÃO OKR" "$W"
        ;;

    # === Bet test validation ===
    *reports/strategy/validation/*.md)
        CONTENT=$(get_content)
        [ -z "$CONTENT" ] && exit 0
        W=""
        echo "$CONTENT" | grep -qE 'id:\s*"?BET-[0-9]{4}-[0-9]{3}"?' || W="${W}Campo 'id' ausente/inválido (BET-YYYY-NNN). "
        echo "$CONTENT" | grep -qE 'status:\s*"?(draft|active|passed|failed|pivoted|cancelled)"?' || W="${W}Campo 'status' ausente/inválido. "
        echo "$CONTENT" | grep -qE 'idea_ref:\s*"?IDEA-[0-9]{4}-[0-9]{3}"?' || W="${W}Campo 'idea_ref' ausente/inválido. "
        echo "$CONTENT" | grep -qE 'validation_method:\s*"?(spike|prototype|data-analysis|competitive-benchmark)"?' || W="${W}Campo 'validation_method' ausente/inválido. "
        echo "$CONTENT" | grep -qE 'confidence_before:\s*[0-9]' || W="${W}Campo 'confidence_before' ausente. "
        echo "$CONTENT" | grep -qi '## Hip' || W="${W}Seção '## Hipótese' ausente. "
        if echo "$CONTENT" | grep -qi '## Hip'; then
            echo "$CONTENT" | grep -qi 'Cremos que' || W="${W}Template 'Cremos que...' ausente na Hipótese. "
        fi
        echo "$CONTENT" | grep -qi '## Assumptions' || W="${W}Seção '## Assumptions Críticas' ausente. "
        [ -n "$W" ] && emit_warning "VALIDAÇÃO BET TEST" "$W"
        ;;

    # === Conception doc validation ===
    *reports/strategy/conception/*.md)
        CONTENT=$(get_content)
        [ -z "$CONTENT" ] && exit 0
        W=""
        echo "$CONTENT" | grep -qE 'id:\s*"?(PRD|OP)-[0-9]{4}-[0-9]{3}"?' || W="${W}Campo 'id' ausente/inválido (PRD-YYYY-NNN ou OP-YYYY-NNN). "
        echo "$CONTENT" | grep -qE 'level:\s*"?(prd|onepager)"?' || W="${W}Campo 'level' ausente/inválido. "
        echo "$CONTENT" | grep -qE 'status:\s*"?(draft|trio-review|ready|promoted)"?' || W="${W}Campo 'status' ausente/inválido. "
        echo "$CONTENT" | grep -qE 'module:\s*"?.+"?' || W="${W}Campo 'module' ausente. "
        echo "$CONTENT" | grep -qE 'created:\s*"?[0-9]{4}-[0-9]{2}-[0-9]{2}"?' || W="${W}Campo 'created' ausente/inválido. "
        LEVEL=$(echo "$CONTENT" | grep -oE 'level:\s*"?(prd|onepager)"?' | grep -oE '(prd|onepager)' | head -1)
        if [ "$LEVEL" = "prd" ]; then
            for i in 1 2 3 4 5 6 7 8; do
                echo "$CONTENT" | grep -qE "## ${i}\." || W="${W}Seção '## ${i}.' ausente (PRD requer 8 seções). "
            done
        fi
        if [ "$LEVEL" = "onepager" ]; then
            echo "$CONTENT" | grep -qi '## Problema' || W="${W}Seção '## Problema' ausente (one-pager). "
            echo "$CONTENT" | grep -qi '## Solucao Proposta' || W="${W}Seção '## Solucao Proposta' ausente (one-pager). "
            echo "$CONTENT" | grep -qi '## Metricas de Sucesso' || W="${W}Seção '## Metricas de Sucesso' ausente (one-pager). "
        fi
        [ -n "$W" ] && emit_warning "VALIDAÇÃO CONCEPÇÃO" "$W"
        ;;

    # === Launch doc / Review doc validation ===
    *reports/strategy/delivery/launches/*.md)
        CONTENT=$(get_content)
        [ -z "$CONTENT" ] && exit 0
        W=""
        echo "$CONTENT" | grep -qE 'id:\s*"?LAUNCH-[0-9]{4}-[0-9]{3}"?' || W="${W}Campo 'id' ausente/inválido (LAUNCH-YYYY-NNN). "
        echo "$CONTENT" | grep -qE 'status:\s*"?(preparing|launched|monitoring|reviewing-d30|reviewing-d90|decided|closed)"?' || W="${W}Campo 'status' ausente/inválido. "
        echo "$CONTENT" | grep -qE 'rollout_type:\s*"?.+"?' || W="${W}Campo 'rollout_type' ausente. "
        echo "$CONTENT" | grep -qE 'module:\s*"?.+"?' || W="${W}Campo 'module' ausente. "
        echo "$CONTENT" | grep -qE 'created:\s*"?[0-9]{4}-[0-9]{2}-[0-9]{2}"?' || W="${W}Campo 'created' ausente/inválido. "
        echo "$CONTENT" | grep -qi '## 2\. Checklist de Lancamento' || W="${W}Seção '## 2. Checklist de Lancamento' ausente. "
        [ -n "$W" ] && emit_warning "VALIDAÇÃO LAUNCH" "$W"
        ;;

    *reports/strategy/delivery/reviews/*.md)
        CONTENT=$(get_content)
        [ -z "$CONTENT" ] && exit 0
        W=""
        echo "$CONTENT" | grep -qE 'launch_ref:\s*"?LAUNCH-[0-9]{4}-[0-9]{3}"?' || W="${W}Campo 'launch_ref' ausente/inválido. "
        echo "$CONTENT" | grep -qE 'review_type:\s*"?(d30|d90)"?' || W="${W}Campo 'review_type' ausente/inválido. "
        [ -n "$W" ] && emit_warning "VALIDAÇÃO REVIEW" "$W"
        ;;

esac

exit 0
