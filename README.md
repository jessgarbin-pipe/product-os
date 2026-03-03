# Product OS v2

> Sistema de inteligencia de produto para o Piperun CRM.
> 36 skills, 19 agents, 3 hooks — do monitoramento ao feedback loop.

## O que e

Product OS e um plugin para [Claude Code](https://docs.anthropic.com/en/docs/claude-code) que automatiza o ciclo completo de produto em 8 fases:

1. **Monitoramento** — metricas de uso, NPS, bugs, churn, sentimento
2. **Continuous Discovery** — painel de clientes, entrevistas, session replays
3. **Coleta e Triagem** — intake de demandas, roteamento dual-path, RICE
4. **Estrategia** — OKRs, OST, ideacao, roadmap com 3 horizontes
5. **Validacao** — testes de aposta, mapeamento de assumptions
6. **Concepcao** — PRDs, one-pagers, issues estruturadas, trio refinement
7. **Delivery** — sprint dashboard, velocity, ship tracking (observer mode)
8. **GTM & Feedback Loop** — launch checklist, D+30/D+90 reviews, decisoes

## Requisitos

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) instalado
- **Pendo MCP** configurado (subscription ID e app ID no `CLAUDE.md`)
- Acesso a **Metabase** via MySQL (dados financeiros)
- Exports do **Movidesk** em CSV (bugs, tickets, feedbacks)

## Instalacao

```bash
claude plugins add product-os@product-os
```

Apos instalar, o plugin adiciona 36 skills (invocaveis via `/comando`) e 19 agents (invocaveis via Task tool) ao seu Claude Code.

## Customizacao

Este plugin e Piperun-especifico por padrao. Para adaptar ao seu produto:

1. **Pendo IDs** — edite `CLAUDE.md`, secao "Pendo — IDs Importantes":
   - `Subscription ID`: seu subscription ID do Pendo
   - `App ID`: seu app ID do Pendo
   - `NPS Guide`: seu guide ID de NPS

2. **Concorrentes** — edite `CLAUDE.md`, secao "Concorrentes Monitorados"

3. **Severidade de Bugs** — edite `CLAUDE.md`, secao "Padroes de Severidade"

4. **Fontes de Dados** — se voce nao usa Metabase ou Movidesk, ajuste as skills que referenciam essas fontes

## Skills (36)

### Fase 1 — Monitoramento

| Comando | Descricao |
|---------|-----------|
| `/monitoring-snapshot` | Resumo executivo semanal consolidado |
| `/usage-monitor` | DAU/WAU/MAU, sessoes, tempo medio |
| `/nps-analysis` | NPS score, promotores vs detratores |
| `/bug-dashboard` | Bugs por severidade, modulo, idade |
| `/bug-sla-check` | Aderencia SLA P0-P3 |
| `/health-score` | Health score por conta |
| `/churn-analysis` | Taxa de churn, motivos, sinais |
| `/sentiment-monitor` | Indice de sentimento agregado |
| `/funnel-analysis` | Funis de conversao, drop-off |
| `/retention-cohort` | Coortes D1/D7/D30, stickiness |
| `/feature-heatmap` | Mapa de adocao de features |
| `/csat-analysis` | CSAT e pesquisas pontuais |
| `/cs-feedback-synthesis` | Sintese semanal feedbacks CS |

### Fase 2 — Continuous Discovery

| Comando | Descricao |
|---------|-----------|
| `/discovery-panel-manager` | Painel fixo de 10-15 clientes |
| `/discovery-prep` | Briefing pre-entrevista |
| `/session-replay-analyzer` | Encontrar e analisar session replays |
| `/discovery-touchpoint-log` | Registrar touchpoint estruturado |
| `/discovery-cadence-report` | Relatorio de cadencia e insights |

### Fase 3 — Coleta e Triagem

| Comando | Descricao |
|---------|-----------|
| `/opportunity-intake` | Registrar demanda de qualquer fonte |
| `/opportunity-backlog-manager` | Ver backlog, promover, rejeitar |
| `/delivery-backlog-sync` | Criar GitHub Issues |
| `/rice-scorer` | RICE score com dados do Pendo |
| `/triage-dashboard` | Dashboard consolidado de triagem |
| `/internal-demand-triage` | Triagem de demandas do Slack |

### Fase 4 — Estrategia

| Comando | Descricao |
|---------|-----------|
| `/okr-manager` | OKRs trimestrais |
| `/ost-builder` | Opportunity Solution Tree |
| `/ideation-log` | Registrar e gerenciar ideias |
| `/roadmap-planner` | Roadmap com 3 horizontes |
| `/strategy-dashboard` | Dashboard estrategico consolidado |

### Fase 5 — Validacao

| Comando | Descricao |
|---------|-----------|
| `/bet-test-manager` | Testes de Aposta |

### Fase 6 — Concepcao

| Comando | Descricao |
|---------|-----------|
| `/conception-manager` | PRD, one-pager ou issue estruturada |

### Fase 7 — Delivery

| Comando | Descricao |
|---------|-----------|
| `/delivery-tracker` | Sprint dashboard, velocity, ship |

### Fase 8 — GTM & Feedback Loop

| Comando | Descricao |
|---------|-----------|
| `/gtm-feedback-loop` | Launch doc, checklist, reviews D+30/D+90 |

### Transversal — Inteligencia de Mercado

| Comando | Descricao |
|---------|-----------|
| `/feature-benchmark` | Comparacao feature-a-feature com concorrentes |
| `/pricing-benchmark` | Pricing, packaging, posicionamento |
| `/trend-report` | Tendencias CRM/SalesTech |

## Agents (19)

| Agent | Fase | Funcao |
|-------|------|--------|
| `anomaly-detector` | 1 | Detectar quedas/picos inesperados |
| `monitoring-alert-generator` | 1 | Alertas quando metricas cruzam thresholds |
| `nps-deep-dive` | 1 | Analise profunda com clusters de comentarios |
| `cs-feedback-clusterer` | 1 | Agrupar feedbacks por tema e sentimento |
| `metrics-correlator` | 1 | Cruzar metricas para encontrar causas |
| `interview-guide-generator` | 2 | Roteiro de entrevista Teresa Torres |
| `discovery-pattern-finder` | 2 | Padroes entre multiplos touchpoints |
| `demand-router` | 3 | Classificar tipo + severidade + rota |
| `demand-synthesizer` | 3 | Sintetizar lote de demandas |
| `bug-classifier` | 3 | Classificar bugs P0-P3 |
| `opportunity-validator` | 3 | Validar antes de promover |
| `okr-alignment-scorer` | 4 | Alinhamento oportunidade-OKR (1-5) |
| `roadmap-optimizer` | 4 | Alocacao otima de roadmap |
| `assumption-mapper` | 5 | Identificar assumptions criticas |
| `prd-enricher` | 6 | Pre-preencher PRD com dados |
| `launch-readiness-checker` | 8 | Verificar readiness pre-launch |
| `post-launch-analyzer` | 8 | Dados Pendo para D+30/D+90 |
| `competitor-monitor` | Transv. | Monitorar mudancas em concorrentes |
| `trend-scanner` | Transv. | Varrer tendencias de mercado |

## 4 Dashboards Executivos

Para uma visao 360 do produto:

```
1. /monitoring-snapshot        Fase 1 — Metricas + Bugs
2. /discovery-cadence-report   Fase 2 — Discovery
3. /triage-dashboard           Fase 3 — Pipeline + SLA
4. /strategy-dashboard         Fases 4-8 — Estrategia
```

## Documentacao

- [Guia completo de uso](docs/product-os-guide.md) — todas as fases, fluxos e cenarios

## Migracao do v1

Se voce usava o Product OS v1 (7 skills genericas):

- **Skills renomeadas**: as 7 skills originais foram incorporadas e expandidas nas 36 skills do v2
- **Configuracao**: o v1 usava `.product-os/config.yml` para multi-produto. O v2 usa `CLAUDE.md` diretamente
- **Agents**: novidade do v2 — 19 agents para analises profundas
- **Hooks**: novidade do v2 — validacao automatica de artefatos

## Licenca

Uso interno Piperun.
