---
name: bet-test-manager
description: "Cria e rastreia Testes de Aposta para ideias com alta incerteza no Piperun. Template obrigatório de hipótese, mapeamento de assumptions críticas (via agent assumption-mapper), registro de método de validação (spike/protótipo/dados/benchmark), gate de Confidence >= 60%. Use SEMPRE que o usuário mencionar: teste de aposta, bet test, validar ideia, validação pré-concepção, testar assumption, criar bet test, resultado da validação, spike de validação, protótipo de validação, a ideia passou?, confidence da ideia, pipeline de validação, validações em andamento, pivotar bet test, reformular hipótese, gate de confidence, ou qualquer variação."
---

# Gestão de Testes de Aposta — Piperun

Skill para criar e rastrear Testes de Aposta (Fase 5 — Validação Pré-Concepção). Antes de investir em PRD completo, toda ideia com alta incerteza passa por um Teste de Aposta para matar ideias ruins rápido e barato.

## Conceito

O Teste de Aposta é a ponte entre decisão estratégica (Fase 4) e concepção técnica (Fase 6):
- Ideias aceitas no `ideation-log` com Confidence < 60% **devem** passar por bet test
- Template obrigatório: "Cremos que [solução] para [segmento] vai resultar em [resultado]"
- Assumptions críticas são mapeadas pelo agent `assumption-mapper`
- Critério de passagem: Confidence >= 60% após validação
- Gate flexível — PM pode overridar com justificativa

```
Fase 4 (Estratégia)              Fase 5 (Validação)              Fase 6 (Concepção)
========================          ========================        ========================
ideation-log (accepted) ────────> Teste de Aposta ──────────────> PRD / One-pager / Issue
ost-builder (solução) ──────────> Métodos de validação ─────────> Trio refinement
roadmap-planner (planned) ──────> Critério: Confidence >= 60% ──> Committed no roadmap
rice-scorer (Confidence) <──────── Atualiza Confidence pós-teste
```

## Fontes de Dados

| Fonte | Localização | O que alimenta |
|-------|-------------|---------------|
| Ideação | `reports/strategy/ideation/ideation-index.json` | Ideias candidatas a bet test |
| Backlog | `reports/backlog/opportunity-index.json` | Oportunidades referenciadas |
| OST | `reports/strategy/ost/ost-index.json` | Soluções em validação |
| Discovery | `reports/discovery/touchpoint-*.md` | Evidências para assumptions |
| Pendo | MCP tools | Dados para análise de dados |
| Validation | `reports/strategy/validation/validation-index.json` | Index de bet tests |

## Storage

### Index: `reports/strategy/validation/validation-index.json`

```json
{
  "version": "1.0",
  "lastUpdated": "2026-03-15",
  "nextId": 1,
  "bets": [
    {
      "id": "BET-2026-001",
      "title": "Título",
      "status": "active",
      "ideaRef": "IDEA-2026-001",
      "opportunityRef": "OPP-2026-005",
      "validationMethod": "prototype",
      "confidenceBefore": 0.5,
      "confidenceAfter": null,
      "created": "2026-03-15",
      "file": "bet-2026-001-slug.md"
    }
  ]
}
```

### Arquivo por bet test: `reports/strategy/validation/bet-YYYY-NNN-slug.md`

**Frontmatter**:
```yaml
---
id: "BET-2026-001"
title: "Título do teste de aposta"
status: draft | active | passed | failed | pivoted | cancelled
idea_ref: "IDEA-2026-001"
opportunity_ref: "OPP-2026-005"
ost_objective: "slug-do-objetivo"
validation_method: spike | prototype | data-analysis | competitive-benchmark
confidence_before: 0.5
confidence_after: null
created: "2026-03-15"
updated: "2026-03-15"
started: null
completed: null
author: "PM"
duration_planned: "1-2 semanas"
duration_actual: null
---
```

**Corpo**:
```markdown
# BET-2026-001 — [Título]

## Hipótese
Cremos que **[solução]** para **[segmento]** vai resultar em **[resultado]**.
Saberemos que funcionou quando **[métrica X mudar Y%]**.

## Assumptions Críticas
(preenchido pelo agent `assumption-mapper` ou pelo PM)

| # | Assumption | Risco | Método de teste | Status | Resultado |
|---|-----------|-------|----------------|--------|-----------|
| 1 | [crença] | alto | [spike/entrevista/dados/benchmark] | pendente | - |
| 2 | [crença] | médio | [método] | validada | [evidência] |
| 3 | [crença] | alto | [método] | invalidada | [evidência] |

## Método de Validação
- **Tipo**: [spike | protótipo + entrevistas | análise de dados | benchmark competitivo]
- **Duração planejada**: [X semanas]
- **Descrição**: [o que será feito concretamente]

## Execução
### Atividades realizadas
- [data]: [atividade e resultado]
- [data]: [atividade e resultado]

### Entrevistas (se protótipo)
| # | Cliente/Perfil | Data | Resultado chave |
|---|---------------|------|----------------|
| 1 | [nome/perfil] | [data] | [insight] |

### Dados coletados (se análise de dados)
- Pendo: [métricas consultadas e resultados]
- Outras fontes: [dados]

## Resultado
- **Confidence antes**: [X]% (RICE original)
- **Confidence depois**: [Y]%
- **Decisão**: passed | failed | pivoted
- **Justificativa**: [por que passou ou falhou]
- **Próximos passos**: [o que fazer com o resultado]

## Impacto no RICE
- RICE antes: [score]
- RICE recalculado: [score] (Confidence atualizada de [X] para [Y])
- Strategic Priority recalculada: [score]
```

## Métodos de Validação

| Método | Quando usar | Duração |
|--------|------------|---------|
| **Spike de validação** | Alta incerteza técnica | 1-2 semanas |
| **Protótipo low-fi + 3-5 entrevistas** | Incerteza de valor/usabilidade | 1-2 semanas |
| **Análise de dados (Pendo)** | Validar reach e patterns de uso | Dias |
| **Benchmark competitivo** | Validar se mercado já resolveu | Dias |

## Lifecycle de Bet Tests

| Status | Significado | Próximo passo |
|--------|------------|--------------|
| `draft` | Template preenchido, assumptions mapeadas | PM inicia validação |
| `active` | Validação em andamento (spike, protótipo, etc.) | Registrar resultados |
| `passed` | Confidence >= 60% — assumptions críticas validadas | Ideia avança para concepção |
| `failed` | Confidence < 60% — assumptions invalidadas | Pivotar, retestar ou rejeitar ideia |
| `pivoted` | Hipótese reformulada baseada nos resultados | Novo bet test com hipótese revisada |
| `cancelled` | Bet test cancelado (ideia rejeitada por outro motivo) | Ideia volta a rejected |

## Operações

### 1. Criar Bet Test
**Trigger**: "criar bet test para IDEA-X", "testar aposta", "validar ideia"

**Fluxo**:
1. PM indica ideia (IDEA-YYYY-NNN) ou descreve
2. Ler ideia completa em `reports/strategy/ideation/`
3. Verificar Confidence atual (se < 60%, bet test recomendado; se >= 60%, informar que pode pular)
4. Pedir ao PM:
   - Hipótese: "Cremos que... vai resultar em... Saberemos quando..."
   - Método de validação preferido
   - Duração planejada
5. Invocar agent `assumption-mapper` (haiku, max 10 turns) para mapear assumptions críticas
6. Gerar ID: `BET-YYYY-NNN` (baseado no nextId do index, ano do campo `created`)
7. Criar arquivo `bet-YYYY-NNN-slug.md`
8. Atualizar `validation-index.json`
9. Atualizar status da ideia para "validating" no `ideation-log` (atualizar arquivo da ideia e ideation-index.json)
10. Atualizar status da solução no OST para "em-validacao" (se existir no OST)

### 2. Registrar Resultado
**Trigger**: "resultado do bet test BET-X", "a validação passou", "bet test falhou"

**Fluxo**:
1. Ler bet test em `reports/strategy/validation/`
2. PM registra:
   - Status de cada assumption (validada/invalidada/inconclusiva)
   - Evidências coletadas
   - Dados de entrevistas/Pendo/benchmark
3. Calcular nova Confidence:
   - Se todas assumptions críticas validadas: Confidence sobe para >= 0.8
   - Se maioria validada mas alguma incerta: Confidence ~0.6-0.8
   - Se assumptions críticas invalidadas: Confidence cai para < 0.5
4. Determinar resultado:
   - `passed`: Confidence final >= 60%
   - `failed`: Confidence final < 60%
5. Atualizar bet test com resultados (status, confidence_after, completed, duration_actual)
6. Atualizar RICE Confidence da oportunidade/ideia via `rice-scorer` recálculo
7. Se `passed`:
   - Atualizar ideia — apta para concepção (voltando para "accepted" com flag `confidence_validated: true`)
   - Atualizar solução no OST para "validada"
8. Se `failed`:
   - Sugerir pivotar (novo bet test com hipótese revisada), retestar (mais dados), ou rejeitar (ideia → rejected)
9. Atualizar `validation-index.json`

### 3. Listar Bet Tests
**Trigger**: "ver bet tests", "validações em andamento", "pipeline de validação"

**Formato**:
```
# Pipeline de Validação — Piperun
**Data**: [data] | **Total**: [N] bet tests

## Por Status
| Status | Quantidade |
|--------|-----------|
| draft | [N] |
| active | [N] |
| passed | [N] |
| failed | [N] |
| pivoted | [N] |

## Bet Tests Ativos
| ID | Ideia | Método | Início | Duração | Assumptions |
|----|-------|--------|--------|---------|------------|
| BET-... | IDEA-... | prototype | [data] | Xd/Yd plan | 2/3 validadas |

## Resultados Recentes
| ID | Ideia | Resultado | Confidence | Delta |
|----|-------|-----------|-----------|-------|
| BET-... | IDEA-... | passed | 50% → 80% | +30pp |
```

### 4. Pivotar Bet Test
**Trigger**: "pivotar bet test", "reformular hipótese"

**Fluxo**:
1. Marcar bet test atual como `pivoted`
2. Criar novo bet test com hipótese revisada
3. Referenciar bet test original nas notas
4. Manter mesma idea_ref e opportunity_ref
5. Atualizar `validation-index.json`

### 5. Gate Check (automático)
**Trigger**: quando PM tenta mover ideia para committed no roadmap ou criar PRD

**Fluxo**:
1. Verificar se item referencia ideia com bet test associado
2. Se Confidence < 60% e sem bet test passed:
   - Alertar: "Esta ideia tem Confidence [X]% e não passou por Teste de Aposta. Deseja prosseguir mesmo assim?"
3. Se Confidence >= 60% (original ou pós-bet-test): OK, pode avançar
4. PM sempre pode overridar (gate flexível) — registrar justificativa no changelog do roadmap

### 6. Iniciar Bet Test
**Trigger**: "iniciar bet test BET-X", "começar validação"

**Fluxo**:
1. Atualizar status de `draft` para `active`
2. Registrar data de início (`started`)
3. Atualizar `validation-index.json`

## Integração com Outras Skills

| Skill/Agent | Direção | Dados |
|-------------|---------|-------|
| `ideation-log` | → bet-test | Ideias "accepted" com Confidence < 60% são candidatas |
| `ideation-log` | ← bet-test | Status atualizado para "validating" durante bet test |
| `ost-builder` | ← bet-test | Solução atualizada para "em-validacao" / "validada" |
| `rice-scorer` | ← bet-test | Confidence recalculada pós-resultado |
| `roadmap-planner` | ← bet-test | Gate check antes de committed |
| `assumption-mapper` | → bet-test | Mapeia assumptions críticas ao criar bet test |
| `discovery-prep` | → bet-test | Reutilizável para preparar entrevistas de validação |
| `session-replay-analyzer` | → bet-test | Reutilizável para análise de dados na validação |
| `feature-benchmark` | → bet-test | Reutilizável para benchmark competitivo na validação |
| `usage-monitor` | → bet-test | Reutilizável para análise de dados (Pendo) na validação |
| `strategy-dashboard` | ← bet-test | Seção 5.5 — Validation Pipeline |

## Observações

- Bet test é obrigatório se Confidence < 60% — mas PM pode pular se já tem evidência forte
- Gate é flexível por design — PM tem a palavra final, mas precisa justificar
- Pivotar é preferível a rejeitar — ajuste de hipótese preserva aprendizado
- Duração alvo: 1-2 semanas por validação — evitar bet tests que arrastam
- Assumptions de maior risco devem ser testadas primeiro
- Hook `strategy-review-reminder.sh` alerta bet tests ativos >14 dias sem resultado
- Após bet test passed, ideia está apta para concepção (PRD, one-pager, GitHub Issue)
