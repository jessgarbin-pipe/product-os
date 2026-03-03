---
name: opportunity-backlog-manager
description: "Gerencia o Opportunity Backlog do Piperun: visualiza, filtra, promove, rejeita e arquiva oportunidades. Controla lifecycle dual-path (Fast Lane / Discovery Lane), detecta duplicatas, monitora aging e capacidade de tech debt. Use SEMPRE que o usuário mencionar: ver backlog, oportunidades abertas, opportunity backlog, o que temos pendente, promover para delivery, rejeitar oportunidade, pipeline de demandas, funil de oportunidades, aging do backlog, duplicatas, ou qualquer variação."
---

# Gestão do Opportunity Backlog

Skill para gerenciar o lifecycle de oportunidades no Opportunity Backlog do Piperun, incluindo visualização, promoção para Delivery, rejeição e métricas de pipeline.

## Fontes de Dados

| Fonte | Localização | O que contém |
|-------|-------------|-------------|
| Opportunity Index | `reports/backlog/opportunity-index.json` | Índice de todas as oportunidades |
| Oportunidades | `reports/backlog/opportunities/OPP-*.md` | Detalhes de cada oportunidade |
| Arquivo | `reports/backlog/archive/` | Oportunidades rejeitadas/mergeadas |
| GitHub Issues | `gh issue list` (via Bash) | Delivery Backlog |

## Pipeline de Status

### Fast Lane
```
new → fast-lane → promoted → shipped → measured
```
- `new`: recém registrada pelo opportunity-intake
- `fast-lane`: classificada como clara pelo demand-router
- `promoted`: GitHub Issue criada via delivery-backlog-sync
- `shipped`: item entregue e lançado (atualizado via `/delivery-tracker` ship item)
- `measured`: feedback loop completo, D+90 review decidido (atualizado via `/gtm-feedback-loop`)

### Discovery Lane
```
new → needs-discovery → researching → scored → validated → in-conception → promoted → shipped → measured | rejected
```
- `new`: recém registrada
- `needs-discovery`: classificada como incerta, aguarda investigação
- `researching`: PM está investigando (discovery, Pendo, etc.)
- `scored`: RICE score calculado (via rice-scorer)
- `validated`: aprovada pelo opportunity-validator
- `in-conception`: em concepcao (Fase 6) — PRD/one-pager sendo elaborado
- `promoted`: GitHub Issue criada
- `shipped`: item entregue e lançado (atualizado via `/delivery-tracker` ship item)
- `measured`: feedback loop completo, D+90 review decidido (atualizado via `/gtm-feedback-loop`)
- `rejected`: descartada (movida para archive)

## Operações

### 1. Visualizar Backlog
**Trigger**: "ver backlog", "oportunidades abertas", "o que temos pendente"

- Ler `reports/backlog/opportunity-index.json`
- Apresentar com filtros aplicáveis:
  - Por lane: fast / discovery
  - Por tipo: bug / tech-debt / feature / improvement
  - Por status: qualquer status do pipeline
  - Por fonte: uma das 7 fontes
  - Por módulo: área do produto
  - Por idade: < 7d, 7-14d, 14-30d, > 30d
  - Por RICE score: ordenar por score

**Formato**:
```
# Opportunity Backlog — Piperun
**Data**: [data] | **Total**: [N] oportunidades ativas

## Pipeline por Lane

### Fast Lane ([N] itens)
| ID | Título | Tipo | Status | Módulo | Idade | Sev. |
|----|--------|------|--------|--------|-------|------|
| OPP-... | [título] | bug | fast-lane | [mod] | Xd | P1 |

### Discovery Lane ([N] itens)
| ID | Título | Tipo | Status | Módulo | Idade | RICE |
|----|--------|------|--------|--------|-------|------|
| OPP-... | [título] | feature | researching | [mod] | Xd | 7.0 |

## Resumo
- Fast Lane: [N] (X% do total)
- Discovery Lane: [N] (X% do total)
- Bugs ativos: [N] (P0: [N], P1: [N], P2: [N], P3: [N])
- Aguardando discovery: [N]
- Com RICE score: [N]
```

### 2. Promover para Delivery (Discovery Lane)
**Trigger**: "promover para delivery", "promover OPP-YYYY-NNN"

**Pré-requisitos para promoção**:
- Feature/Melhoria: RICE score deve estar presente
- Bug: severidade P0-P3 deve estar definida
- Tech Debt: justificativa deve estar presente

**Fluxo**:
1. Ler oportunidade completa
2. Verificar pré-requisitos
3. Delegar validação ao agent `opportunity-validator` (sonnet)
4. Se `opportunity-validator` recomenda PROMOVER:
   - Atualizar status para `validated`
   - Sugerir ao PM criar GitHub Issue via `/delivery-backlog-sync`
5. Se recomenda PRECISA MAIS EVIDÊNCIA:
   - Manter status atual
   - Apresentar o que falta e sugerir próximos passos
6. Se recomenda REJEITAR/MERGEAR:
   - Apresentar justificativa ao PM para decisão final

### 3. Promover Fast Lane (direto)
**Trigger**: oportunidade com `lane: fast` e `status: fast-lane`

- Fast Lane não precisa de validação do opportunity-validator
- Ir direto para criação de GitHub Issue via `/delivery-backlog-sync`

### 4. Rejeitar/Arquivar
**Trigger**: "rejeitar OPP-YYYY-NNN", "arquivar oportunidade"

1. Perguntar motivo ao PM (obrigatório)
2. Atualizar status para `rejected`
3. Adicionar motivo no arquivo
4. Mover arquivo para `reports/backlog/archive/`
5. Atualizar `opportunity-index.json`

### 5. Detecção de Duplicatas
**Trigger**: "duplicatas no backlog", "oportunidades similares"

- Comparar títulos, módulos e tags entre todas as oportunidades ativas
- Incluir comparação entre Fast Lane e Discovery Lane
- Comparar com GitHub Issues existentes
- Apresentar pares suspeitos para PM decidir se mergea

### 6. Aging Alerts
**Trigger**: "aging do backlog", automático em visualização

- Oportunidades `needs-discovery` paradas há mais de 14 dias → **ALERTA**
- Formato: "⚠️ OPP-YYYY-NNN está há [N] dias em needs-discovery sem progresso"
- Sugerir ação: avançar para researching, rejeitar, ou reclassificar

### 7. Capacidade Tech Debt
**Trigger**: "capacidade tech debt", "% tech debt"

- Contar GitHub Issues com label `type:tech-debt` (abertas)
- Contar total de GitHub Issues abertas
- Calcular %
- Meta: 15-20% da capacidade
- Se < 15%: "Abaixo da meta de tech debt. Considere promover itens de tech debt do backlog."
- Se > 20%: "Acima da meta de tech debt. Considere priorizar features/melhorias."
- Listar oportunidades de tech debt no Opportunity Backlog prontas para promover

### 8. Atualizar Status
**Trigger**: "atualizar status de OPP-YYYY-NNN para X"

- Validar transição de status (seguir pipeline)
- Atualizar arquivo .md (frontmatter `status` e `updated`)
- Atualizar `opportunity-index.json`

### 9. Strategic View (Fase 4)
**Trigger**: "visão estratégica do backlog", "backlog por OKR", "strategic view", "oportunidades alinhadas", "gap estratégico"

Agrupa oportunidades por OKR e destaca alinhamentos e gaps.

**Fluxo**:
1. Ler `reports/backlog/opportunity-index.json`
2. Ler OKRs ativos em `reports/strategy/okrs/` (se existirem)
3. Para cada oportunidade scored com `okr_alignment` ou `linked_okrs`:
   - Agrupar por objetivo OKR alinhado
4. Identificar gaps:
   - **RICE alto sem OKR** (gap estratégico): oportunidades com RICE >5 e alignment <=2 ou sem alignment
   - **OKR sem oportunidades** (gap de cobertura): objetivos sem nenhuma oportunidade linkada

**Formato**:
```
# Strategic View — Opportunity Backlog
**Data**: [data] | **Quarter**: [YYYY-QN]

## Por OKR

### Objetivo 1: [Título]
| ID | Título | Tipo | RICE | OKR Align | Strat.Prio | Status |
|----|--------|------|------|----------|-----------|--------|
| OPP-... | [título] | feature | 8.5 | 5 | 12.75 | scored |

### Objetivo 2: [Título]
| ID | Título | Tipo | RICE | OKR Align | Strat.Prio | Status |
|----|--------|------|------|----------|-----------|--------|
| OPP-... | [título] | improvement | 6.0 | 4 | 7.80 | researching |

### Sem alinhamento OKR
| ID | Título | Tipo | RICE | Status | Nota |
|----|--------|------|------|--------|------|
| OPP-... | [título] | feature | 7.0 | scored | RICE alto — considerar alinhamento |

## Gaps
- **RICE alto sem OKR**: [N] oportunidades — pode indicar gap na definição de OKRs
- **OKRs sem cobertura**: [lista de objetivos sem oportunidades] — risco para KRs
```

**Filtros adicionais** (Fase 4):
- Por OKR alignment: aligned (score >=3) / unaligned (score <=2) / all
- Colunas adicionais na tabela padrão: OKR | Strat.Prio

**Se OKRs não existem**: informar que Fase 4 ainda não foi iniciada e apresentar backlog normal

## Métricas de Pipeline

```
## Funil por Lane
### Fast Lane
intake → fast-lane → promoted
  [N]      [N]         [N]
Taxa de promoção: X%
Tempo médio intake→promoted: Xd

### Discovery Lane
intake → needs-discovery → researching → scored → validated → promoted
  [N]        [N]              [N]          [N]       [N]         [N]
Taxa de promoção: X%
Taxa de rejeição: X%
Tempo médio intake→promoted: Xd
Gargalo: [etapa com mais acúmulo]
```

## Campos opcionais do opportunity-index.json (Fase 4)

Quando a Fase 4 está ativa, oportunidades podem conter campos adicionais:

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `okr_alignment` | number (1-5) | Score de alinhamento com OKR, preenchido pelo `okr-alignment-scorer` |
| `strategic_priority` | number | RICE × OKR_Alignment_Factor, preenchido pelo `rice-scorer` |
| `linked_okrs` | string[] | Lista de referências de OKRs linkados (ex: "Obj 1 — KR 1.1") |
| `ost_node` | string | Slug do objetivo no OST onde a oportunidade está (ex: "aumentar-retencao") |
| `conception_ref` | string | ID do documento de concepcao associado (ex: "PRD-2026-001", "OP-2026-001") |

Estes campos são opcionais e backward compatible — oportunidades sem eles funcionam normalmente.

## Observações

- PM tem a palavra final em todas as decisões (promover, rejeitar, mergear)
- Aging alerts são sugestões, não bloqueios — PM pode ter motivo para manter parado
- Duplicatas entre lanes são esperadas (alguém pediu via Slack, outro via discovery) — isso reforça a demanda
- Tech debt capacity é referência, não regra rígida — PM ajusta conforme contexto da sprint
- Nunca deletar oportunidades — sempre mover para archive com motivo
- Strategic View (Fase 4) só está disponível quando existem OKRs ativos — sem OKRs, backlog funciona normalmente
- Status `in-conception` indica que a oportunidade está em concepcao (Fase 6) — doc de concepcao sendo elaborado via `/conception-manager`
- Status `shipped` indica que o item foi entregue e lançado — atualizado em cascata pelo `/delivery-tracker` ship item (Fase 7)
- Status `measured` indica que o feedback loop foi completado — D+90 review decidido via `/gtm-feedback-loop` (Fase 8)
