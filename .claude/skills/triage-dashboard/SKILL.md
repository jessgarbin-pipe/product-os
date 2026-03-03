---
name: triage-dashboard
description: "Dashboard consolidado de triagem do Piperun: pipeline por lane (Fast/Discovery), Delivery Backlog, SLA compliance atualizado, capacidade tech debt, métricas semanais, aging alerts e atribuição de fonte. Use SEMPRE que o usuário mencionar: dashboard de triagem, triage dashboard, visão geral do backlog, status da triagem, como está o pipeline, overview de demandas, métricas de backlog, SLA atual, capacidade de tech debt, ou qualquer variação."
---

# Dashboard Consolidado de Triagem

Skill para gerar visão executiva completa do pipeline de triagem do Piperun, consolidando Opportunity Backlog + Delivery Backlog + SLA + capacidade.

## Fontes de Dados

| Fonte | Localização | O que contém |
|-------|-------------|-------------|
| Opportunity Index | `reports/backlog/opportunity-index.json` | Oportunidades ativas |
| Oportunidades | `reports/backlog/opportunities/OPP-*.md` | Detalhes com timestamps |
| Arquivo | `reports/backlog/archive/` | Rejeitadas para métricas |
| GitHub Issues | `gh issue list` (via Bash) | Delivery Backlog |

## SLAs de Referência

Ver tabela completa de Bug SLAs P0-P3 no CLAUDE.md (seção "Padrões de Severidade de Bugs").

## Fluxo de Execução

### 1. Coletar dados
- Ler `reports/backlog/opportunity-index.json`
- Ler arquivos de oportunidade para detalhes (datas, status)
- Consultar GitHub Issues: `gh issue list --label "source:product-os" --state all --json number,title,labels,createdAt,closedAt,state`
- Contar oportunidades arquivadas em `reports/backlog/archive/`

### 2. Gerar dashboard

## Formato de Saída

```
# Dashboard de Triagem — Piperun
**Data**: [data] | **Período de referência**: últimos 7 dias

---

## 1. Pipeline por Lane

### Fast Lane
```
intake → fast-lane → promoted (delivery)
  [N]      [N]         [N]
```
- Tempo médio intake → promoted: [X] dias
- Volume últimos 7 dias: [N] novas
- % do total: [X%]

### Discovery Lane
```
intake → needs-discovery → researching → scored → validated → promoted
  [N]        [N]              [N]          [N]       [N]         [N]
```
- Tempo médio intake → promoted: [X] dias
- Volume últimos 7 dias: [N] novas
- Taxa de promoção: [X%]
- Taxa de rejeição: [X%]
- Gargalo: [etapa com mais acúmulo]

### Comparativo
| Métrica | Fast Lane | Discovery Lane |
|---------|-----------|---------------|
| Volume total | N | N |
| % do pipeline | X% | X% |
| Tempo médio até delivery | Xd | Xd |
| Taxa de sucesso | X% | X% |

---

## 2. Delivery Backlog (GitHub Issues)

| Métrica | Valor |
|---------|-------|
| Issues abertas | N |
| Criadas esta semana | N |
| Fechadas esta semana | N |
| Net (criadas - fechadas) | +/-N |
| Trend | [crescendo/estável/diminuindo] |

### Por Tipo
| Tipo | Abertas | % |
|------|---------|---|
| Bug | N | X% |
| Feature | N | X% |
| Improvement | N | X% |
| Tech Debt | N | X% |

### Por Módulo (top 5)
| Módulo | Abertas | Trend |
|--------|---------|-------|
| [módulo] | N | [+/-] |

---

## 3. SLA Compliance

### Bugs Ativos por Severidade
| Sev. | Abertas | SLA Resp. | SLA Correção | Status |
|------|---------|-----------|-------------|--------|
| P0 | N | 30min | 4h | [OK / VIOLAÇÃO — Xh excedido] |
| P1 | N | 2h | 24h | [OK / VIOLAÇÃO — Xh excedido] |
| P2 | N | 24h | Sprint corrente | [OK / ATRASADO] |
| P3 | N | Backlog | Próxima sprint | [OK / ATRASADO] |

### Alertas de SLA
- 🚨 [P0 em violação — detalhes, tempo excedido, ação necessária]
- ⚠️ [P1 próximo do limite — detalhes]

---

## 4. Capacidade Tech Debt

| Métrica | Valor | Meta |
|---------|-------|------|
| Issues tech-debt abertas | N | — |
| % do Delivery Backlog | X% | 15-20% |
| Status | [OK / Abaixo / Acima] | |

### Se abaixo de 15%:
- Sugestão: promover tech debt do Opportunity Backlog
- Candidatos: [listar OPP-* de tech-debt prontos]

### Se acima de 20%:
- Sugestão: priorizar features/melhorias
- Features com maior RICE: [listar top 3]

---

## 5. Métricas Semanais

### Novas Oportunidades (últimos 7 dias)
| Fonte | Qty | Fast | Discovery |
|-------|-----|------|-----------|
| customer-suggestion | N | N | N |
| internal-sales | N | N | N |
| internal-cs | N | N | N |
| pm-discovery | N | N | N |
| bug-report | N | N | N |
| tech-debt | N | N | N |
| monitoring-insight | N | N | N |
| **Total** | **N** | **N** | **N** |

### Movimentações
- Promovidas para Delivery: [N]
- Rejeitadas: [N]
- Bugs resolvidos: [N] (criados: [N])
- RICE scores calculados: [N]

---

## 6. Discovery Lane Aging

| ID | Título | Status | Dias parado | Ação sugerida |
|----|--------|--------|-------------|---------------|
| OPP-... | [título] | needs-discovery | 18d | Iniciar pesquisa ou rejeitar |
| OPP-... | [título] | researching | 21d | Calcular RICE ou rejeitar |

⚠️ [N] oportunidades paradas há mais de 14 dias em Discovery Lane

---

## 7. Atribuição de Fonte

### Ranking por Volume
| # | Fonte | Total | Promovidas | Taxa Promoção |
|---|-------|-------|-----------|---------------|
| 1 | [fonte] | N | N | X% |
| 2 | [fonte] | N | N | X% |

### Fonte com maior conversão: [fonte] ([X%])
### Fonte com maior volume: [fonte] ([N])

---

_Gerado via Product OS — Triage Dashboard_
_Complementa: `/monitoring-snapshot` (Fase 1) + `/discovery-cadence-report` (Fase 2)_
```

## Exemplo

**Input**: "Como está o pipeline de triagem?"

**Output**: Dashboard completo mostrando:
- Fast Lane: 12 itens (8 promovidos, 4 aguardando)
- Discovery Lane: 18 itens (3 promoted, 6 researching, 5 needs-discovery, 2 scored, 2 rejected)
- Delivery: 23 issues abertas (+5 esta semana, -3 fechadas, net +2, crescendo)
- SLA: P0 OK (0 ativos), P1 ALERTA (1 próximo do SLA)
- Tech Debt: 14% — ligeiramente abaixo da meta
- 3 oportunidades paradas há 14+ dias em Discovery Lane
- Fonte mais produtiva: internal-cs (32% de taxa de promoção)

## Observações

- Este dashboard complementa `/monitoring-snapshot` (Fase 1) e `/discovery-cadence-report` (Fase 2) para uma visão executiva completa
- Se não houver oportunidades no backlog, gerar dashboard simplificado e sugerir registrar demandas via `/opportunity-intake`
- SLA compliance deve ser o primeiro item verificado — P0/P1 em violação é prioridade máxima
- Aging alerts devem ser apresentados proativamente, não apenas quando pedidos
