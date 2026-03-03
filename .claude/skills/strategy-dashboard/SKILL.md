---
name: strategy-dashboard
description: "Dashboard estratégico consolidado do Piperun: OKR progress, OST coverage, roadmap status, Strategic Priority ranking, ideation pipeline, validation pipeline, conception pipeline, delivery pipeline e GTM pipeline. Análogo ao monitoring-snapshot (Fase 1) e triage-dashboard (Fase 3). Use SEMPRE que o usuário mencionar: dashboard de estratégia, strategy dashboard, visão estratégica, como estamos no quarter, OKR + roadmap, overview estratégico, status da estratégia, executive strategy review, big picture, delivery pipeline, launch pipeline, ou qualquer variação."
---

# Dashboard Estratégico Consolidado — Piperun

Dashboard master das Fases 4-8, análogo ao `monitoring-snapshot` (Fase 1) e `triage-dashboard` (Fase 3). Consolida todas as dimensões estratégicas, delivery e GTM em uma visão executiva.

## Fontes de Dados

| Fonte | Localização | Seção |
|-------|-------------|-------|
| OKRs | `reports/strategy/okrs/okrs-*.md` | Seção 1 — OKR Progress |
| OST | `reports/strategy/ost/ost-index.json` + `ost-*.md` | Seção 2 — OST Coverage |
| Roadmap | `reports/strategy/roadmap/roadmap-current.json` | Seção 3 — Roadmap Status |
| RICE + OKR | Oportunidades scored | Seção 4 — Strategic Priority |
| Ideação | `reports/strategy/ideation/ideation-index.json` | Seção 5 — Ideation Pipeline |
| Validação | `reports/strategy/validation/validation-index.json` | Seção 5.5 — Validation Pipeline |
| Concepcao | `reports/strategy/conception/conception-index.json` | Seção 6 — Conception Pipeline |
| Delivery | `reports/strategy/delivery/delivery-index.json` + sprints/ | Seção 8 — Delivery Pipeline |
| Launches | `reports/strategy/delivery/launches/*.md` | Seção 9 — GTM Pipeline |
| Reviews | `reports/strategy/delivery/reviews/*.md` | Seção 9 — GTM Pipeline |
| Changelogs | `reports/strategy/delivery/changelogs/*.md` | Seção 9 — GTM Pipeline |
| Backlog | `reports/backlog/opportunity-index.json` | Seção 10 — Ponte Operacional |
| Discovery | `reports/discovery/touchpoint-*.md` | Seção 7 — Ponte Operacional |
| Bugs | Oportunidades tipo bug no backlog | Seção 7 — Ponte Operacional |
| Pendo | MCP tools | KR progress, métricas de impacto |

## Formato de Saída

```markdown
# Strategy Dashboard — Piperun
**Data**: [data] | **Quarter**: [YYYY-QN] | **Dias restantes**: [N]

---

## 1. OKR Progress

### Resumo
| Objetivo | Progresso | Status | KRs on-track | KRs at-risk | KRs off-track |
|----------|-----------|--------|-------------|------------|--------------|
| Obj 1: [título] | [X%] | on-track | [N] | [N] | [N] |
| Obj 2: [título] | [X%] | at-risk | [N] | [N] | [N] |

### KRs At-Risk (ação necessária)
| Objetivo | KR | Progresso | Gap | Sugestão |
|----------|-----|-----------|-----|---------|
| Obj 1 | KR 1.2 | 30% (esperado: 60%) | -30pp | Acelerar [solução X] no roadmap |

**Score médio geral**: [X] / 1.0

---

## 2. OST Coverage

### Por Objetivo
| Objetivo | Oportunidades | Com solução | Shipped | Medidas | Órfãs |
|----------|--------------|------------|---------|---------|-------|
| Obj 1 | [N] | [N] | [N] | [N] | [N] |
| Obj 2 | [N] | [N] | [N] | [N] | [N] |

### Alertas
- **Oportunidades órfãs** (sem touchpoints >30d): [lista]
- **Oportunidades sem OKR**: [N] — gap estratégico
- **Impacto medido**: [N] soluções com resultado real

---

## 3. Roadmap Status

### Committed — [Quarter]
| Status | Quantidade | % |
|--------|-----------|---|
| Done | [N] | [X%] |
| In-progress | [N] | [X%] |
| Not-started | [N] | [X%] |
| At-risk | [N] | [X%] |

**Progresso geral**: [X%] done

### Pipeline Próximo Quarter
- Planned: [N] itens para [Q+1]
- Oportunidades validadas sem roadmap: [N] — considerar inclusão

### Itens At-Risk
| ID | Título | Motivo | Impacto em OKR |
|----|--------|--------|---------------|
| RM-003 | [título] | [bloqueio] | KR 2.1 em risco |

---

## 4. Strategic Priority Ranking

### Top 10 Oportunidades
| # | ID | Título | RICE | OKR Align | Strat.Prio | Status |
|---|-----|--------|------|----------|-----------|--------|
| 1 | OPP-... | [título] | 8.5 | 5 (Direto) | 12.75 | roadmap |
| 2 | OPP-... | [título] | 7.0 | 4 (Forte) | 9.10 | scored |

### Desalinhamentos
- **RICE alto sem OKR** (gap estratégico): [lista de OPPs com RICE >5 e alignment <=2]
- **OKR forte sem RICE** (gap de evidência): [lista de OKRs com poucas OPPs scored]

---

## 5. Ideation Pipeline

| Status | Quantidade |
|--------|-----------|
| Proposed | [N] |
| Evaluating | [N] |
| Accepted | [N] |
| Rejected | [N] |
| Shipped | [N] |

- **Taxa de aceitação**: [X%] (accepted / total decididas)
- **Ideias esta semana**: [N]
- **Sem avaliação há >14d**: [N] — avaliar na próxima sessão

---

## 5.5 Validation Pipeline (Fase 5)

| Status | Quantidade |
|--------|-----------|
| active | [N] |
| passed (último mês) | [N] |
| failed (último mês) | [N] |

### Bet Tests Ativos
| ID | Ideia | Método | Duração | Progress |
|----|-------|--------|---------|----------|
| BET-... | IDEA-... | prototype | [N]d / [N]d plan | [N]/[N] assumptions |

### Ideias bloqueadas (Confidence < 60%, sem bet test)
| Ideia | Confidence | Status | Sugestão |
|-------|-----------|--------|---------|
| IDEA-... | [X]% | accepted | Criar bet test via /bet-test-manager |

**Taxa de passagem**: [X%] (passed / total decididos)

---

## 6. Conception Pipeline (Fase 6)

| Status | Quantidade |
|--------|-----------|
| draft | [N] |
| trio-review | [N] |
| ready | [N] |
| promoted (ultimo mes) | [N] |

### Por Nivel
| Nivel | Quantidade |
|-------|-----------|
| PRD | [N] |
| One-pager | [N] |

### Documentos em Progresso
| ID | Titulo | Nivel | Status | Modulo | Trio? | Idade | Alerta |
|----|--------|-------|--------|--------|-------|-------|--------|
| PRD-... | [titulo] | PRD | draft | [mod] | Nao | Xd | draft >7d |
| OP-... | [titulo] | One-pager | trio-review | [mod] | Parcial | Xd | trio >14d |

### Alertas de Concepcao
- **Draft >7d**: [lista de docs parados em draft ha mais de 7 dias]
- **Trio-review >14d**: [lista de docs em trio-review ha mais de 14 dias]
- **Ready >7d**: [lista de docs prontos nao promovidos ha mais de 7 dias]

### Metricas
- **Tempo medio draft→ready**: [N] dias
- **Tempo medio ready→promoted**: [N] dias
- **Taxa de trio complete**: [X%]

---

## 8. Delivery Pipeline (Fase 7)

### Sprint Status
| Métrica | Valor |
|---------|-------|
| Sprint atual | S[N] |
| Completion rate (último sprint) | [X%] |
| Velocity (média 4 sprints) | [N] issues |
| Velocity trend | [crescendo/estável/diminuindo] |

### Shipped This Quarter
| ID | Título | Tipo | Shipped Date | Launch? |
|----|--------|------|-------------|---------|
| RM-... | [título] | [tipo] | [data] | [LAUNCH-... / pendente] |

### Carryover
- Issues carryover do último sprint: [N]
- % da capacidade em carryover: [X%]
- Composição: roadmap [X%] / tech-debt [X%] / emergências [X%]

---

## 9. GTM Pipeline (Fase 8)

### Launches por Status
| Status | Qtd |
|--------|-----|
| preparing | [N] |
| launched | [N] |
| monitoring | [N] |
| reviewing-d30 | [N] |
| reviewing-d90 | [N] |
| decided | [N] |
| closed | [N] |

### Reviews Pendentes
| Launch | Tipo | Data Prevista | Atraso |
|--------|------|-------------|--------|
| LAUNCH-... | D+30 | [data] | [N] dias |
| LAUNCH-... | D+90 | [data] | [N] dias |

### Decisões Recentes (último mês)
| Launch | Decisão | Data | Resultado |
|--------|---------|------|----------|
| LAUNCH-... | [iterate/scale/disable/maintain] | [data] | [resumo] |

### Changelog Cadence
- Último changelog interno: [data] ([N] dias atrás) — Meta: semanal
- Último changelog externo: [data] ([N] dias atrás) — Meta: mensal
- Status: [em dia / atrasado]

---

## 10. Ponte Operacional (Fases 1-3)

### Backlog Pipeline
- Fast Lane: [N] itens (P0: [N], P1: [N])
- Discovery Lane: [N] itens
- Total ativo: [N]
- Aging >30 dias: [N] — atenção

### Bugs P0/P1 Impactando Roadmap
| Bug | Severidade | Módulo | Impacto em roadmap |
|-----|-----------|--------|-------------------|
| OPP-... | P0 | [módulo] | Bloqueia RM-001 |

### Discovery
- Touchpoints este mês: [N]
- Touchpoints conectados ao OST: [N] ([X%])
- Padrões emergentes: [lista do pattern-finder se disponível]

---

## Recomendações

### Ações Estratégicas Prioritárias
1. **[Ação 1]**: [justificativa baseada nos dados acima]
2. **[Ação 2]**: [justificativa]
3. **[Ação 3]**: [justificativa]

### Riscos
- [Risco 1]: [descrição e mitigação sugerida]
- [Risco 2]: [descrição e mitigação sugerida]
```

## Fluxo de Execução

### 1. Coletar dados de OKRs
- Ler OKRs ativos em `reports/strategy/okrs/`
- Para cada KR com fonte Pendo: buscar valor atual via MCP
- Calcular progresso e status

### 2. Coletar dados do OST
- Ler `reports/strategy/ost/ost-index.json`
- Para cada árvore, contar: oportunidades, com solução, shipped, medidas
- Detectar órfãs (último touchpoint >30 dias)

### 3. Coletar dados do Roadmap
- Ler `reports/strategy/roadmap/roadmap-current.json`
- Calcular distribuição por status
- Identificar itens at-risk

### 4. Calcular Strategic Priority Ranking
- Ler `reports/backlog/opportunity-index.json`
- Filtrar oportunidades com `rice_score` e `okr_alignment`
- Calcular Strategic Priority = RICE × OKR_Alignment_Factor
- Ordenar e apresentar top 10
- Detectar desalinhamentos

### 5. Coletar dados de Ideação
- Ler `reports/strategy/ideation/ideation-index.json`
- Contar por status
- Calcular taxa de aceitação

### 5.5. Coletar dados de Validação (Fase 5)
- Ler `reports/strategy/validation/validation-index.json`
- Contar bet tests por status (active, passed, failed, pivoted)
- Identificar bet tests ativos com duração > 14 dias → alerta
- Identificar ideias com Confidence < 60% sem bet test associado
- Calcular taxa de passagem: passed / (passed + failed)

### 5.6. Coletar dados de Concepcao (Fase 6)
- Ler `reports/strategy/conception/conception-index.json`
- Contar docs por status (draft, trio-review, ready, promoted) e nivel (prd, onepager)
- Identificar docs draft >7 dias → alerta aging
- Identificar docs trio-review >14 dias → alerta aging
- Identificar docs ready >7 dias → alerta (prontos nao promovidos)
- Calcular tempo medio draft→ready e ready→promoted
- Calcular taxa de trio complete

### 5.7. Coletar dados de Delivery (Fase 7)
- Ler sprint reviews recentes em `reports/strategy/delivery/sprints/`
- Calcular velocity média dos últimos 4 sprints
- Identificar velocity trend (crescendo/estável/diminuindo)
- Listar items shipped no quarter atual (do roadmap-current.json com status `done`)
- Calcular carryover do último sprint

### 5.8. Coletar dados de GTM (Fase 8)
- Ler `reports/strategy/delivery/delivery-index.json`
- Contar launches por status
- Identificar reviews D+30/D+90 pendentes (baseado em launchedDate + 30/90 dias)
- Listar decisões recentes (último mês)
- Verificar cadência de changelog: último interno e externo

### 6. Coletar dados operacionais (Ponte)
- Ler `reports/backlog/opportunity-index.json` para backlog pipeline
- Filtrar bugs P0/P1 ativos
- Contar touchpoints recentes em `reports/discovery/`
- Verificar conexão touchpoints ↔ OST

### 7. Gerar recomendações
Baseado nos dados coletados:
- KRs at-risk → acelerar soluções relacionadas
- Oportunidades RICE alto sem roadmap → considerar inclusão
- Bugs P0/P1 → impacto em roadmap
- Ideias sem avaliação → sessão de ideação
- Touchpoints não conectados ao OST → linkar

## Integração — Visão Executiva Completa

Para uma visão executiva de 360 graus do produto, o PM pode rodar os 4 dashboards:

| Dashboard | Fase | Foco |
|-----------|------|------|
| `/monitoring-snapshot` | 1 | Métricas de uso, NPS, bugs, sentimento |
| `/discovery-cadence-report` | 2 | Cadência de discovery, touchpoints, padrões |
| `/triage-dashboard` | 3 | Pipeline de triagem, SLA, delivery backlog |
| `/strategy-dashboard` | 4+5+6+7+8 | OKRs, OST, roadmap, priorização, validation, conception, delivery, GTM |

**Dica**: Na sexta-feira, rodar os 4 dashboards em sequência dá uma visão completa de 360° do estado do produto — desde métricas de uso (F1) até feedback loop pós-lançamento (F8). O strategy-dashboard agora inclui Seções 8 (Delivery Pipeline) e 9 (GTM Pipeline) além de Validation (5.5) e Conception (6).

## Observações

- Este dashboard lê dados de todas as fases — se alguma fase não tiver dados, seção correspondente informa "Dados não disponíveis"
- Se `reports/strategy/` não existe ou está vazio, informar que Fase 4 ainda não foi iniciada
- Recomendações são sugestões baseadas em dados — PM tem a palavra final
- Para análise profunda de qualquer seção, o PM pode usar a skill específica
- Frequência recomendada: semanal (hook `strategy-review-reminder.sh` verifica cadência)
