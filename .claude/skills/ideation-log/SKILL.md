---
name: ideation-log
description: "Registra e gerencia ideias de solução conectadas ao OST do Piperun. Lifecycle: proposed > evaluating > accepted > validating > conceiving > rejected > shipped > measured. Sessão semanal de ideação para oportunidade priorizada. Use SEMPRE que o usuário mencionar: registrar ideia, ideação, brainstorm, proposta de solução, opções para, alternativas para, nova ideia, sessão de ideação, weekly ideation, listar ideias, ou qualquer variação."
---

# Registro de Ideias de Solução — Piperun

Skill para registrar, pontuar e gerenciar ideias de solução conectadas a oportunidades no Opportunity Solution Tree (OST).

## Conceito

Ideias são propostas de solução para oportunidades identificadas via discovery. Cada ideia tem:
- Conexão com uma oportunidade no OST
- RICE preliminar (refinado quando aceita)
- Lifecycle claro: proposed → evaluating → accepted → validating → conceiving → rejected / shipped → measured
- Ideias aceitas tornam-se soluções no OST e candidatas ao roadmap
- Status `measured` indica que o feedback loop foi completado (D+90 review decidido via `/gtm-feedback-loop`)

## Fontes de Dados

| Fonte | Localização | O que alimenta |
|-------|-------------|---------------|
| OST | `reports/strategy/ost/ost-index.json` | Oportunidades para ideias |
| Backlog | `reports/backlog/opportunity-index.json` | Referência de oportunidades |
| Discovery | `reports/discovery/touchpoint-*.md` | Evidências e insights |
| Pattern Finder | Agent `discovery-pattern-finder` | Padrões que geram ideias |
| Pendo | MCP tools | Dados para RICE preliminar |

## Storage

### Index: `reports/strategy/ideation/ideation-index.json`

```json
{
  "version": "1.0",
  "lastUpdated": "2026-03-15",
  "nextId": 1,
  "ideas": [
    {
      "id": "IDEA-2026-001",
      "title": "Título da ideia",
      "status": "proposed",
      "opportunityRef": "OPP-2026-005",
      "ostObjective": "slug-do-objetivo",
      "rice_score": null,
      "created": "2026-03-15",
      "file": "idea-2026-001-slug.md"
    }
  ]
}
```

### Arquivo por ideia: `reports/strategy/ideation/idea-YYYY-NNN-slug.md`

**Frontmatter**:
```yaml
---
id: "IDEA-2026-001"
title: "Título da ideia"
status: proposed | evaluating | accepted | validating | conceiving | rejected | shipped | measured
opportunity_ref: "OPP-2026-005"
ost_objective: "slug-do-objetivo"
ost_solution_id: "SOL-001"
module: "pipeline"
rice_score: null
effort_estimate: "M"
created: "2026-03-15"
updated: "2026-03-15"
author: "PM"
tags: ["filtros", "ux", "pipeline"]
---
```

**Corpo**:
```markdown
# IDEA-2026-001 — [Título]

## Problema que resolve
[Qual oportunidade/dor esta ideia endereça. Referência: OPP-YYYY-NNN]

## Descrição da solução
[Descrição clara do que seria construído/modificado]

## Evidências que suportam
- [Touchpoint X: "usuário relatou dificuldade com..."]
- [Pendo: rage clicks na feature Y = N/dia]
- [NPS: 3 detratores mencionam o tema]

## Alternativas consideradas
1. **[Alternativa A]**: [descrição] — descartada porque [motivo]
2. **[Alternativa B]**: [descrição] — possível se [condição]

## RICE Preliminar
- **Reach**: [estimativa] — [justificativa]
- **Impact**: [estimativa] — [justificativa]
- **Confidence**: [estimativa] — [justificativa]
- **Effort**: [T-shirt: XS/S/M/L/XL] — [justificativa]
- **RICE**: [score ou "pendente"]

## Decisão
- **Status**: [proposed/evaluating/accepted/rejected/shipped]
- **Motivo**: [por que foi aceita/rejeitada]
- **Data**: [data da decisão]
```

## Lifecycle de Ideias

| Status | Significado | Próximo passo |
|--------|------------|--------------|
| `proposed` | Registrada, aguarda avaliação | PM avalia na sessão semanal |
| `evaluating` | Em análise, coletando mais dados | Aceitar ou rejeitar |
| `accepted` | Aprovada — vira solução no OST e candidata ao roadmap | Validar (se Confidence < 60%) ou adicionar ao roadmap |
| `validating` | Em Teste de Aposta (Fase 5) — validando assumptions | Registrar resultado do bet test |
| `conceiving` | Em concepcao (Fase 6) — PRD/one-pager sendo elaborado | Trio refina e promove para delivery |
| `rejected` | Descartada com motivo registrado | Arquivo para referência futura |
| `shipped` | Implementada e lançada | Medir resultado via D+30/D+90 review |
| `measured` | Feedback loop completo (D+90 review decidido) | Ciclo encerrado — learnings registrados |

## Operações

### 1. Registrar Ideia
**Trigger**: "registrar ideia", "nova ideia", "proposta de solução para OPP-X"

**Fluxo**:
1. PM descreve a ideia
2. Identificar oportunidade relacionada (OPP-YYYY-NNN)
3. Identificar objetivo do OST relacionado (se OST existir)
4. Gerar ID: `IDEA-YYYY-NNN` (baseado no nextId do index)
5. Pedir ao PM:
   - Módulo afetado
   - Effort estimate (T-shirt)
   - Tags relevantes
6. Calcular RICE preliminar:
   - Reach: estimar baseado na oportunidade
   - Impact: herdar da oportunidade se disponível
   - Confidence: geralmente 0.5 (palpite) para ideias novas
   - Effort: do PM
7. Criar arquivo `idea-YYYY-NNN-slug.md`
8. Atualizar `ideation-index.json`
9. Informar PM do ID gerado

### 2. Listar Ideias
**Trigger**: "ver ideias", "listar ideias", "pipeline de ideação"

**Formato**:
```
# Pipeline de Ideação — Piperun
**Data**: [data] | **Total**: [N] ideias

## Por Status
| Status | Quantidade |
|--------|-----------|
| proposed | [N] |
| evaluating | [N] |
| accepted | [N] |
| rejected | [N] |
| shipped | [N] |

## Ideias Ativas (proposed + evaluating)
| ID | Título | Oportunidade | Módulo | RICE | Effort | Idade |
|----|--------|-------------|--------|------|--------|-------|
| IDEA-2026-001 | [título] | OPP-2026-005 | pipeline | 3.5 | M | 5d |

## Aceitas (aguardando roadmap)
| ID | Título | Oportunidade | RICE | Próximo passo |
|----|--------|-------------|------|--------------|
| IDEA-2026-002 | [título] | OPP-2026-003 | 7.0 | Adicionar ao roadmap |
```

### 3. Avaliar Ideia
**Trigger**: "avaliar IDEA-YYYY-NNN", "aceitar ideia", "rejeitar ideia"

**Fluxo para aceitar**:
1. Ler ideia completa
2. Atualizar status para `accepted`
3. Registrar motivo da aceitação
4. Adicionar como solução no OST (via `ost-builder`)
5. Verificar Confidence atual:
   - Se Confidence < 60%: sugerir enviar para validação (Fase 5) via `/bet-test-manager`
   - Se Confidence >= 60%: sugerir adição direta ao roadmap (via `roadmap-planner`)
6. Atualizar index

**Fluxo para enviar para validação** (Fase 5):
1. Ler ideia completa
2. Atualizar status para `validating`
3. Criar bet test via `/bet-test-manager` (que invocará o agent `assumption-mapper`)
4. Atualizar index

**Fluxo para rejeitar**:
1. Perguntar motivo ao PM (obrigatório)
2. Atualizar status para `rejected`
3. Registrar motivo
4. Atualizar index

### 4. Sessão Semanal de Ideação
**Trigger**: "sessão de ideação", "weekly ideation", "brainstorm para OPP-X"

**Fluxo**:
1. Identificar oportunidade priorizada (maior RICE no OST ou indicada pelo PM)
2. Coletar contexto:
   - Ler oportunidade completa
   - Ler touchpoints relacionados em `reports/discovery/`
   - Consultar frustration metrics no Pendo
   - Verificar monitoring-snapshot recente
3. Gerar briefing de ideação:
   ```
   ## Briefing — Sessão de Ideação
   **Oportunidade**: OPP-YYYY-NNN — [título]
   **Dor**: [resumo da dor]
   **Evidências**: [N] touchpoints, frustration score: [X]
   **Soluções existentes no OST**: [lista ou "nenhuma"]
   ```
4. PM propõe ideias (registrar cada uma via operação 1)
5. Ao final, resumir ideias registradas na sessão

### 5. Resumo Semanal de Ideação
**Trigger**: "resumo de ideação", "ideação da semana"

- Contar ideias registradas nos últimos 7 dias
- Listar por status
- Taxa de aceitação: accepted / (accepted + rejected) * 100
- Ideias proposed há mais de 14 dias sem avaliação → alerta

## Integração com Outras Skills

| Skill/Agent | Direção | Dados |
|-------------|---------|-------|
| `ost-builder` | ← ideação | Ideias aceitas tornam-se soluções no OST |
| `rice-scorer` | → ideação | RICE formal para ideias em avaliação |
| `roadmap-planner` | ← ideação | Ideias aceitas são candidatas ao roadmap |
| `bet-test-manager` | ← ideação | Ideias "accepted" com Confidence < 60% vão para validação (Fase 5) |
| `conception-manager` | ← ideação | Ideias "accepted"/"validating" com Confidence >= 60% vão para concepcao (Fase 6) |
| `delivery-tracker` | ← ideação | Ship item atualiza ideia para `shipped` |
| `gtm-feedback-loop` | ← ideação | Feedback loop decision atualiza ideia para `measured` |
| `discovery-touchpoint-log` | → ideação | Touchpoints geram insight para ideias |
| `discovery-pattern-finder` | → ideação | Padrões cross-discovery geram ideias |
| `strategy-dashboard` | ← ideação | Seção 5 — Ideation Pipeline |

## Observações

- Ideação é semanal — manter cadência é importante (hook `strategy-review-reminder.sh`)
- RICE preliminar é estimativa rápida — scoring formal via `rice-scorer` quando ideia avança
- Alternativas são tão importantes quanto a ideia principal — documentar sempre
- Ideias rejeitadas ficam para referência — o contexto pode mudar
- Sessão de ideação deve considerar monitoring + discovery, não apenas intuição
