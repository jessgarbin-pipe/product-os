---
name: delivery-tracker
description: "Observador inteligente do processo de delivery do Piperun. Le dados do GitHub (Projects + Issues), apresenta sprint dashboards, sugere composicao de sprints, rastreia rollout e marca items como shipped com cascata de atualizacoes. NAO gerencia sprints diretamente — Observer Mode. Use SEMPRE que o usuario mencionar: sprint, delivery pipeline, velocity, cycle time, rollout status, ship item, sprint review, sugerir sprint, WIP, o que esta em dev, sprint dashboard, lead time, throughput, carryover, fechar sprint, composicao do sprint, ou qualquer variacao."
---

# Tracking de Delivery — Piperun

Skill para observar e medir o processo de delivery. Le dados do GitHub (Projects + Issues), apresenta dashboards, sugere composicao de sprints e rastreia rollout. **NAO gerencia sprints diretamente** — o PM e os devs continuam usando GitHub normalmente.

## Principio: Observer Mode

O Product OS **sugere sprints** e **le dados do GitHub**, mas **nao gerencia** sprints diretamente. O PM e os devs continuam usando GitHub normalmente. O Product OS observa, mede e sugere.

## Fontes de Dados

| Fonte | Localizacao | O que alimenta |
|-------|-------------|---------------|
| GitHub Issues | `gh issue list` (via Bash) | Sprint items, status, assignees |
| GitHub Projects | `gh project item-list` (via Bash) | Sprint board, status columns |
| Roadmap | `reports/strategy/roadmap/roadmap-current.json` | Items committed para sugestao |
| Backlog | `reports/backlog/opportunity-index.json` | Tech debt, bugs P0/P1 |
| Launch Docs | `reports/strategy/delivery/launches/*.md` | Rollout status |
| Delivery Index | `reports/strategy/delivery/delivery-index.json` | Launches em andamento |
| Conception | `reports/strategy/conception/conception-index.json` | Items promoted |
| Sprint Reviews | `reports/strategy/delivery/sprints/sprint-review-*.md` | Historico de velocity |

## Storage

### Sprint Reviews: `reports/strategy/delivery/sprints/sprint-review-YYYY-SNN.md`

```yaml
---
sprint: "S01"
year: 2026
start_date: "2026-03-03"
end_date: "2026-03-14"
planned: 12
done: 10
carryover: 2
completion_rate: 83
velocity: 10
cycle_time_avg: 4.5
created: "2026-03-14"
---
```

## Operacoes

### 1. Sprint Dashboard
**Trigger**: "sprint dashboard", "status do sprint", "como esta o sprint"

**Fluxo**:
1. Ler GitHub Issues abertas via `gh issue list --label "source:product-os" --state open --json number,title,labels,assignees,state`
2. Se disponivel, ler GitHub Project via `gh project item-list [PROJECT_NUMBER] --format json`
3. Classificar issues por status (In Progress, Done, Not Started) baseado em labels/project columns
4. Calcular WIP por assignee
5. Identificar bloqueios (issues com label `blocked` ou sem atividade >5 dias)
6. Calcular composicao (roadmap vs bugs/tech-debt)

**Formato**:
```markdown
# Sprint Dashboard — Sprint [N] ([data-inicio] a [data-fim])

## Status
| Status | Qtd | % |
|--------|-----|---|
| In Progress | [N] | [X%] |
| Done | [N] | [X%] |
| Not Started | [N] | [X%] |

## WIP (Work in Progress)
| Dev | Issues ativas | WIP Limit | Status |
|-----|--------------|-----------|--------|
| [nome] | [N] | 2-3 | [OK/Excedido] |

## Bloqueios
| Issue | Bloqueio | Desde | Impacto |
|-------|----------|-------|---------|
| #[N] | [descricao] | [data] | [impacto] |

## Composicao
- Roadmap items: [N] ([X%]) — Meta: 80%
- Bugs/tech-debt: [N] ([X%]) — Meta: 20%
- P0/P1 emergenciais: [N]
```

### 2. Sprint Suggestion
**Trigger**: "sugerir sprint", "o que colocar no sprint", "planejar sprint"

**Fluxo**:
1. Ler `reports/strategy/roadmap/roadmap-current.json` → items committed not-started + in-progress
2. Ler bugs P0/P1 abertos via `gh issue list --label "severity:P0,severity:P1" --state open`
3. Ler tech debt queue via `gh issue list --label "type:tech-debt" --state open`
4. Ler sprint reviews anteriores para velocity media
5. Calcular capacidade estimada baseada em velocity
6. Montar sugestao:
   - ~80% roadmap items priorizados por Strategic Priority (do roadmap-current.json)
   - ~15-20% tech debt items
   - Reserva para P0/P1 emergenciais
   - Respeitar WIP limits e dependencias entre issues
   - Considerar carryover do sprint anterior

**Formato**:
```markdown
# Sugestao de Sprint — Sprint [N+1]

## Capacidade Estimada
- Velocity media (ultimos 4 sprints): [N] issues/sprint
- Capacidade estimada: [N] issues

## Sugestao de Composicao

### Roadmap (~80% = [N] issues)
| # | Issue | Titulo | Strat.Prio | Roadmap ID | Motivo |
|---|-------|--------|-----------|-----------|--------|
| 1 | #[N] | [titulo] | 12.5 | RM-001 | Committed, highest priority |

### Tech Debt (~15% = [N] issues)
| # | Issue | Titulo | Idade | Motivo |
|---|-------|--------|-------|--------|
| 1 | #[N] | [titulo] | [N]d | [motivo] |

### Reserva P0/P1
- P0 abertos: [N] — resolucao imediata
- P1 abertos: [N] — resolver neste sprint

### Carryover do Sprint [N]
| Issue | Titulo | Motivo do carryover |
|-------|--------|-------------------|
| #[N] | [titulo] | [motivo] |

## Notas
- [observacao sobre dependencias, bloqueios, riscos]

> **Acao**: PM revisa sugestao e executa no GitHub. Product OS nao cria/move issues.
```

### 3. Sprint Review
**Trigger**: "sprint review", "review do sprint", "fechar sprint"

**Fluxo**:
1. PM informa numero do sprint e datas (ou inferir do ultimo sprint review)
2. Coletar metricas via `gh issue list --state all --json number,title,labels,createdAt,closedAt,assignees`
3. Filtrar issues do periodo do sprint
4. Calcular: planned, done, carryover, completion rate, velocity
5. Calcular cycle time medio (created → closed)
6. Identificar bugs introduzidos no periodo
7. Calcular composicao efetiva (roadmap vs tech-debt vs emergencias)
8. Salvar review em `reports/strategy/delivery/sprints/sprint-review-YYYY-SNN.md`

**Formato**:
```markdown
# Sprint Review — Sprint [N]
**Periodo**: [data-inicio] a [data-fim]

## Metricas
| Metrica | Valor |
|---------|-------|
| Planned | [N] |
| Done | [N] |
| Carryover | [N] |
| Completion rate | [X%] |
| Velocity (issues) | [N] |
| Cycle time medio | [N] dias |
| Bugs introduzidos | [N] |

## Composicao Efetiva
| Tipo | Qtd | % | Meta |
|------|-----|---|------|
| Roadmap | [N] | [X%] | 80% |
| Tech debt | [N] | [X%] | 15-20% |
| Emergencias | [N] | [X%] | - |

## Items Done
| Issue | Titulo | Tipo | Cycle Time |
|-------|--------|------|-----------|
| #[N] | [titulo] | [tipo] | [N]d |

## Carryover para Sprint [N+1]
| Issue | Titulo | Motivo | Impacto em roadmap |
|-------|--------|--------|-------------------|
| #[N] | [titulo] | [motivo] | [impacto] |

## Velocity Trend (ultimos 4 sprints)
| Sprint | Velocity | Completion Rate |
|--------|----------|----------------|
| S[N-3] | [N] | [X%] |
| S[N-2] | [N] | [X%] |
| S[N-1] | [N] | [X%] |
| S[N] | [N] | [X%] |

**Trend**: [crescendo/estavel/diminuindo]
```

### 4. Rollout Tracker
**Trigger**: "rollout status", "como esta o rollout", "tracker de rollout"

**Fluxo**:
1. Ler `reports/strategy/delivery/delivery-index.json`
2. Filtrar launches com status `launched` ou `monitoring`
3. Ler cada launch doc para extrair rollout plan e progresso
4. Apresentar rollouts em andamento

**Formato**:
```markdown
# Rollout Tracker — Piperun
**Data**: [data]

## Rollouts em Andamento
| Launch | Titulo | Tipo | Fase Atual | % Usuarios | Status | Guardrails |
|--------|--------|------|-----------|-----------|--------|-----------|
| LAUNCH-2026-001 | [titulo] | gradual-rapido | Fase 2/3 | 30% | OK | Sem violacao |

## Rollouts Concluidos (ultimo mes)
| Launch | Titulo | Tipo | Duracao | Resultado |
|--------|--------|------|---------|----------|
| LAUNCH-2026-001 | [titulo] | direto | 1d | OK |

## Guardrails em Alerta
| Launch | Guardrail | Threshold | Valor Atual | Status |
|--------|----------|----------|------------|--------|
```

### 5. Delivery Pipeline
**Trigger**: "delivery pipeline", "pipeline de delivery", "fluxo de desenvolvimento"

**Fluxo**:
1. Ler `reports/strategy/conception/conception-index.json` → docs promoted (entrada)
2. Ler GitHub Issues abertas via `gh issue list --label "source:product-os" --state open`
3. Ler GitHub Issues fechadas recentes via `gh issue list --label "source:product-os" --state closed`
4. Ler `reports/strategy/delivery/delivery-index.json` → launches (saida)
5. Consolidar fluxo

**Formato**:
```markdown
# Delivery Pipeline — Piperun
**Data**: [data]

## Fluxo
| Fase | Qtd | Items |
|------|-----|-------|
| Conception (promoted) | [N] | [lista IDs] |
| In Development | [N] | [lista issues] |
| In Review | [N] | [lista issues] |
| Staging | [N] | [lista issues] |
| Production (shipped) | [N] | [lista issues] |
| Launched (GTM) | [N] | [lista launches] |

## Funil (ultimo quarter)
- Conception → Dev: [N] items
- Dev → Shipped: [N] items ([X%] conversion)
- Shipped → Launched: [N] items ([X%] conversion)
- Tempo medio total (conception → launch): [N] dias
```

### 6. Ship Item
**Trigger**: "ship RM-001", "marcar como shipped", "item entregue"

**Fluxo**:
1. PM indica item do roadmap (RM-NNN) ou GitHub Issue (#NNN)
2. Ler item no roadmap via `reports/strategy/roadmap/roadmap-current.json`
3. Atualizar em cascata:
   a. **Roadmap**: status → `done`, `shippedDate` → hoje
   b. **Oportunidade no backlog**: status → `shipped` (ler `opportunityRef` do item)
      - Atualizar frontmatter do arquivo OPP-*.md
      - Atualizar opportunity-index.json
   c. **Ideia no ideation-log**: status → `shipped` (ler `ideaRef` do item)
      - Atualizar frontmatter do arquivo idea-*.md
      - Atualizar ideation-index.json
   d. **Solucao no OST**: status → `shipped` (se existir no OST)
      - Atualizar ost-index.json e arquivo ost-*.md
4. Registrar no changelog do roadmap
5. Sugerir criar launch doc via `/gtm-feedback-loop`

**Formato**:
```markdown
# Ship — [Titulo do Item]

## Item
- **Roadmap ID**: RM-[NNN]
- **Titulo**: [titulo]
- **Shipped Date**: [hoje]

## Atualizacoes em Cascata
| Sistema | Ref | Status Anterior | Status Novo | OK |
|---------|-----|----------------|-------------|-----|
| Roadmap | RM-[NNN] | in-progress | done | [ok/erro] |
| Oportunidade | OPP-[YYYY-NNN] | promoted | shipped | [ok/erro] |
| Ideia | IDEA-[YYYY-NNN] | conceiving | shipped | [ok/erro] |
| OST Solucao | [slug] | em-progresso | shipped | [ok/erro] |

## Proximo Passo
Criar launch doc para GTM: `/gtm-feedback-loop criar launch para RM-[NNN]`
```

### 7. Velocity Metrics
**Trigger**: "velocity", "cycle time", "lead time", "throughput"

**Fluxo**:
1. Ler GitHub Issues via `gh issue list --label "source:product-os" --state all --json number,title,createdAt,closedAt,labels`
2. Ler sprint reviews anteriores em `reports/strategy/delivery/sprints/`
3. Calcular metricas expandidas:
   - **Cycle time**: tempo medio issue aberta → fechada (ultimos 30 dias)
   - **Lead time**: tempo medio oportunidade registrada → issue fechada (cruzar com backlog)
   - **Throughput**: issues fechadas por sprint (ultimos 4 sprints)
   - **Trend**: crescendo/estavel/diminuindo

**Formato**:
```markdown
# Velocity Metrics — Piperun
**Periodo**: ultimos 30 dias | **Data**: [data]

## Metricas
| Metrica | Valor | Trend |
|---------|-------|-------|
| Cycle Time (medio) | [N] dias | [↑/→/↓] |
| Lead Time (medio) | [N] dias | [↑/→/↓] |
| Throughput | [N] issues/sprint | [↑/→/↓] |

## Cycle Time por Tipo
| Tipo | Medio | P50 | P90 |
|------|-------|-----|-----|
| Bug | [N]d | [N]d | [N]d |
| Feature | [N]d | [N]d | [N]d |
| Improvement | [N]d | [N]d | [N]d |
| Tech Debt | [N]d | [N]d | [N]d |

## Throughput (ultimos 4 sprints)
| Sprint | Issues Fechadas | Velocity |
|--------|----------------|----------|
| S[N-3] | [N] | [N] |
| S[N-2] | [N] | [N] |
| S[N-1] | [N] | [N] |
| S[N] | [N] | [N] |

**Trend geral**: [crescendo/estavel/diminuindo]
```

## Integracao com Outras Skills

| Skill/Agent | Direcao | Dados |
|-------------|---------|-------|
| `roadmap-planner` | → delivery | Items committed alimentam sprint suggestion |
| `roadmap-planner` | ← delivery | Ship item atualiza status e shippedDate |
| `delivery-backlog-sync` | → delivery | GitHub Issues sao a base do sprint |
| `opportunity-backlog-manager` | ← delivery | Ship item atualiza oportunidade para shipped |
| `ideation-log` | ← delivery | Ship item atualiza ideia para shipped |
| `ost-builder` | ← delivery | Ship item atualiza solucao para shipped |
| `gtm-feedback-loop` | ← delivery | Ship item sugere criar launch doc |
| `conception-manager` | → delivery | Items promoted entram no delivery pipeline |
| `strategy-dashboard` | ← delivery | Secao 8 — Delivery Pipeline |
| `bug-sla-check` | → delivery | P0/P1 alimentam sprint suggestion |

## Observacoes

- **Observer Mode**: Product OS le dados do GitHub, nao cria/move issues diretamente (exceto ship item que atualiza arquivos locais)
- Sprint suggestion e uma **sugestao** — PM decide e executa no GitHub
- Sprint review deve ser feito ao final de cada sprint (a cada 2 semanas)
- Hook `strategy-review-reminder.sh` alerta se sprint review esta atrasado >14 dias
- WIP limit padrao: 2-3 issues por dev — exceder indica sobrecarga
- Composicao meta: 80% roadmap + 15-20% tech debt + reserva P0/P1
- Velocity trend usa ultimos 4 sprints para suavizar variabilidade
- Ship item faz cascata de atualizacoes — verificar se todos os refs existem antes de atualizar
