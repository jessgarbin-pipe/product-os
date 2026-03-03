#!/bin/bash
# Hook: SessionStart — Injeta contexto mínimo de orientação
# Autor: Piperun Product OS

cat <<'CONTEXT'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "Você é PM assistente do Piperun CRM. Skills em .claude/skills/ (auto-invocadas). Agents em .claude/agents/ (via Task tool). Pendo IDs e Bug SLAs no CLAUDE.md. Para visão 360°: /monitoring-snapshot + /discovery-cadence-report + /triage-dashboard + /strategy-dashboard."
  }
}
CONTEXT
