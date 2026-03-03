# Product OS — Guia de Uso

> Sistema de inteligencia de produto do Piperun CRM.
> 36 skills, 19 agents, 8 fases — do monitoramento ao feedback loop.

---

## Arquitetura Geral

```
                          ┌─────────────────────────────────────┐
                          │         PRODUCT OS — PIPERUN        │
                          └──────────────┬──────────────────────┘
                                         │
              ┌──────────────────────────┼──────────────────────────┐
              │                          │                          │
     ┌────────▼────────┐      ┌──────────▼──────────┐    ┌────────▼────────┐
     │   FONTES DE     │      │    SKILLS (36)      │    │   AGENTS (19)   │
     │     DADOS       │      │  Invocacao direta   │    │  Via Task tool  │
     │                 │      │  pelo PM via /cmd   │    │  Analise prof.  │
     ├─────────────────┤      └──────────┬──────────┘    └────────┬────────┘
     │ Pendo (MCP)     │               │                          │
     │ Metabase (SQL)  │               ▼                          ▼
     │ Movidesk (CSV)  │      ┌──────────────────────────────────────────┐
     │ Slack (manual)  │      │              OUTPUTS                     │
     │ Web (search)    │      │  reports/ — relatorios, dashboards,      │
     └─────────────────┘      │  backlog, estrategia, launches           │
                              └──────────────────────────────────────────┘
```

---

## O Ciclo Completo — 8 Fases

```
  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
  │  FASE 1  │───▶│  FASE 2  │───▶│  FASE 3  │───▶│  FASE 4  │
  │ Monitor  │    │ Discover │    │ Triagem  │    │Estrategia│
  │          │    │          │    │          │    │          │
  │ Metricas │    │Entrevista│    │ Intake + │    │ OKR+OST+ │
  │ NPS Bugs │    │ Replay   │    │ Backlog  │    │ Roadmap  │
  └──────────┘    └──────────┘    └──────────┘    └──────────┘
                                                        │
  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌─────▼────┐
  │  FASE 8  │◀───│  FASE 7  │◀───│  FASE 6  │◀───│  FASE 5  │
  │   GTM    │    │ Delivery │    │Concepcao │    │Validacao │
  │          │    │          │    │          │    │          │
  │ Launch + │    │ Sprint + │    │ PRD/OP + │    │Bet Test +│
  │ D+30/90  │    │  Ship    │    │  Trio    │    │Prototipos│
  └──────────┘    └──────────┘    └──────────┘    └──────────┘
       │
       └──────────▶ Feedback Loop ──────────▶ volta para Fase 1
```

---

## Fase 1 — Monitoramento

> **Pergunta-chave**: "Como esta o produto hoje?"

### Skills Principais

| Comando | O que faz | Fonte |
|---------|-----------|-------|
| `/usage-monitor` | DAU/WAU/MAU, sessoes, tempo medio | Pendo |
| `/nps-analysis` | NPS score, promotores vs detratores | Pendo |
| `/bug-dashboard` | Bugs por severidade, modulo, idade | Movidesk CSV |
| `/health-score` | Health score por conta | Pendo+Movidesk |
| `/churn-analysis` | Taxa de churn, motivos, sinais | Pendo+Metabase |
| `/sentiment-monitor` | Indice de sentimento agregado | Todas |
| `/monitoring-snapshot` | **Resumo executivo semanal** | Todas |

### Skills Complementares

| Comando | O que faz |
|---------|-----------|
| `/funnel-analysis` | Funis de conversao, drop-off |
| `/retention-cohort` | Coortes D1/D7/D30, stickiness |
| `/feature-heatmap` | Mapa de adocao de features |
| `/csat-analysis` | CSAT e pesquisas pontuais |
| `/cs-feedback-synthesis` | Sintese de feedbacks do CS |
| `/bug-sla-check` | Aderencia SLA P0-P3 |

### Agents Automaticos

| Agent | Modelo | Quando usar |
|-------|--------|-------------|
| `anomaly-detector` | Haiku | Detectar quedas/picos inesperados |
| `monitoring-alert-generator` | Haiku | Gerar alertas quando metricas cruzam thresholds |
| `nps-deep-dive` | Sonnet | Analise profunda com clusters de comentarios |
| `cs-feedback-clusterer` | Sonnet | Agrupar feedbacks por tema e sentimento |
| `metrics-correlator` | Sonnet | Cruzar metricas para encontrar causas |

### Rotina Sugerida

```
Segunda-feira:
  /monitoring-snapshot          ← resumo da semana anterior
  (se anomalia) delegar ao anomaly-detector

Quarta-feira:
  /nps-analysis                 ← checar NPS
  /bug-sla-check                ← checar SLA de bugs

Sexta-feira:
  /sentiment-monitor            ← sentimento geral
  /health-score conta=X         ← contas em risco
```

---

## Fase 2 — Continuous Discovery

> **Pergunta-chave**: "O que os usuarios realmente fazem e sentem?"

### Skills

| Comando | O que faz |
|---------|-----------|
| `/discovery-panel-manager` | Gerenciar painel fixo de 10-15 clientes |
| `/discovery-prep` | Briefing pre-entrevista com dados Pendo+Movidesk |
| `/session-replay-analyzer` | Encontrar e analisar session replays |
| `/discovery-touchpoint-log` | Registrar touchpoint (entrevista, observacao) |
| `/discovery-cadence-report` | Relatorio de cadencia e insights acumulados |

### Agents

| Agent | Modelo | Quando usar |
|-------|--------|-------------|
| `interview-guide-generator` | Haiku | Gerar roteiro de entrevista Teresa Torres |
| `discovery-pattern-finder` | Sonnet | Encontrar padroes entre multiplos touchpoints |

### Fluxo Tipico

```
1. /discovery-panel-manager           ← quem entrevistar?
2. /discovery-prep conta=Acme         ← briefing pre-entrevista
3. (entrevista acontece)
4. /discovery-touchpoint-log          ← registrar notas estruturadas
5. /discovery-cadence-report          ← ver acumulado semanal

Meta: >= 1 touchpoint por semana (hook verifica automaticamente)
```

### Os 4 Campos Obrigatorios de um Touchpoint

```
┌─────────────────────────────────────────────┐
│ ## Comportamento Observado                  │
│ O que o usuario FEZ (nao o que disse)       │
├─────────────────────────────────────────────┤
│ ## Dores Identificadas                      │
│ Frustracoes, gaps, impedimentos             │
├─────────────────────────────────────────────┤
│ ## Oportunidades                            │
│ Conexao com estrategia e produto            │
├─────────────────────────────────────────────┤
│ ## Evidencia                                │
│ Citacoes diretas, fatos, dados              │
└─────────────────────────────────────────────┘
```

---

## Fase 3 — Coleta e Triagem

> **Pergunta-chave**: "O que entrou? Para onde vai?"

### Skills

| Comando | O que faz |
|---------|-----------|
| `/opportunity-intake` | Registrar demanda de qualquer fonte |
| `/opportunity-backlog-manager` | Ver backlog, promover, rejeitar, arquivar |
| `/delivery-backlog-sync` | Criar GitHub Issues, ver delivery backlog |
| `/rice-scorer` | Calcular RICE score com dados do Pendo |
| `/triage-dashboard` | Dashboard consolidado de triagem |
| `/internal-demand-triage` | Triagem de demandas do Slack |

### Agents

| Agent | Modelo | Quando usar |
|-------|--------|-------------|
| `demand-router` | Haiku | Classificar tipo + severidade + rota |
| `demand-synthesizer` | Haiku | Sintetizar lote de demandas |
| `bug-classifier` | Haiku | Classificar bugs P0-P3 |
| `opportunity-validator` | Sonnet | Validar antes de promover |

### Roteamento Dual-Path

```
Demanda bruta
     │
     ▼
 ┌───────────┐
 │  demand-  │     tipo + severidade + certeza
 │  router   │─────────────────────────────────┐
 └───────────┘                                  │
     │                                          │
     ▼                                          ▼
┌─────────────────┐                 ┌─────────────────────┐
│   FAST LANE     │                 │   DISCOVERY LANE    │
│                 │                 │                     │
│ Demanda clara   │                 │ Demanda incerta     │
│ Bug c/ repro    │                 │ Feature vaga        │
│ P0/P1 SEMPRE    │                 │ Tendencia s/ dado   │
│                 │                 │                     │
│    ▼            │                 │    ▼                │
│ GitHub Issue    │                 │ Opportunity Backlog │
│ (delivery)      │                 │ → discovery → RICE  │
│                 │                 │ → promover → Issue  │
└─────────────────┘                 └─────────────────────┘
```

### 7+1 Fontes Aceitas

```
customer-suggestion    ← feedback direto de cliente
internal-sales         ← pedido do time de vendas
internal-cs            ← pedido do CS
internal-implantation  ← pedido de implantacao
pm-discovery           ← insight de discovery (Fase 2)
bug-report             ← bug reportado (Movidesk/Slack)
tech-debt              ← debito tecnico identificado
monitoring-insight     ← anomalia/alerta (Fase 1)
```

---

## Fase 4 — Estrategia

> **Pergunta-chave**: "Para onde estamos indo? O que priorizar?"

### Skills

| Comando | O que faz |
|---------|-----------|
| `/okr-manager` | Criar, acompanhar e revisar OKRs trimestrais |
| `/ost-builder` | Opportunity Solution Tree (OKR > Oportunidade > Solucao) |
| `/ideation-log` | Registrar e gerenciar ideias de solucao |
| `/roadmap-planner` | Roadmap com 3 horizontes |
| `/strategy-dashboard` | Dashboard estrategico consolidado |

### Agents

| Agent | Modelo | Quando usar |
|-------|--------|-------------|
| `okr-alignment-scorer` | Haiku | Classificar alinhamento oportunidade-OKR (1-5) |
| `roadmap-optimizer` | Sonnet | Sugerir alocacao otima de roadmap |

### Roadmap — 3 Horizontes

```
┌─────────────────────────────────────────────────────────────┐
│                       ROADMAP                                │
├───────────────┬──────────────────┬──────────────────────────┤
│  COMMITTED    │     PLANNED      │      EXPLORATORY         │
│  (Q atual)    │     (Q+1)        │      (Q+2+)              │
│               │                  │                          │
│  Alta certeza │  Media certeza   │  Baixa certeza           │
│  Em execucao  │  Pode mudar      │  Direcao sem compromisso │
└───────────────┴──────────────────┴──────────────────────────┘
```

### Strategic Priority

```
Strategic Priority = RICE x OKR_Alignment_Factor

OKR Alignment:
  5 (Direto)   → fator 1.5x
  4 (Forte)    → fator 1.3x
  3 (Moderado) → fator 1.0x
  2 (Fraco)    → fator 0.8x
  1 (Nenhum)   → fator 0.6x
```

### Cadencias

```
Semanal:  /ideation-log (sessao de ideacao)
Mensal:   /okr-manager check-in + /ost-builder review
Quarter:  /roadmap-planner planning + /okr-manager create
```

---

## Fase 5 — Validacao Pre-Concepcao

> **Pergunta-chave**: "Essa ideia funciona antes de investir pesado?"

### Skill

| Comando | O que faz |
|---------|-----------|
| `/bet-test-manager` | Criar e rastrear Testes de Aposta |

### Agent

| Agent | Modelo | Quando usar |
|-------|--------|-------------|
| `assumption-mapper` | Haiku | Identificar assumptions criticas de uma ideia |

### Quando Validar?

```
Ideia aceita no /ideation-log
         │
         ▼
   Confidence >= 60%? ──── SIM ──▶ Pula para Fase 6 (Concepcao)
         │
        NAO
         │
         ▼
   /bet-test-manager create
         │
         ▼
   ┌─────────────────────────────┐
   │  TESTE DE APOSTA            │
   │                             │
   │  "Cremos que [solucao]      │
   │   para [segmento]           │
   │   vai resultar em [X].      │
   │   Saberemos que funcionou   │
   │   quando [metrica mudar Y%]"│
   └─────────────────────────────┘
         │
         ▼
   Metodos: spike tecnico | prototipo + entrevistas
            analise Pendo | benchmark competitivo
         │
         ▼
   /bet-test-manager result
         │
    ┌────┴────┐
    ▼         ▼
  PASSED    FAILED
  >= 60%    < 60%
    │         │
    ▼         ▼
  Fase 6    Pivotar, retestar ou rejeitar
```

---

## Fase 6 — Concepcao

> **Pergunta-chave**: "Como construir isso? Quem precisa estar envolvido?"

### Skill

| Comando | O que faz |
|---------|-----------|
| `/conception-manager` | Criar PRD, one-pager ou issue estruturada |

### Agent

| Agent | Modelo | Quando usar |
|-------|--------|-------------|
| `prd-enricher` | Sonnet | Pre-preencher PRD com dados Pendo+discovery |

### Niveis de Documentacao

```
┌─────────────────────────────────────────────────────┐
│                                                      │
│   Bug / Tech Debt / Improvement XS-S                │
│   ─────────────────────────────────                  │
│   → Issue Estruturada (leve)                        │
│     Contexto + criterios de aceite + JTBD           │
│                                                      │
├──────────────────────────────────────────────────────┤
│                                                      │
│   Improvement M / Feature XS-S                      │
│   ────────────────────────────                       │
│   → One-Pager (medio)                               │
│     Problema + Solucao + Metricas + Trio + Rollout  │
│                                                      │
├──────────────────────────────────────────────────────┤
│                                                      │
│   Improvement L-XL / Feature M-XL / RICE >= 8       │
│   ──────────────────────────────────────────         │
│   → PRD Completo (robusto)                          │
│     8 secoes + trio refinement + rollout plan       │
│                                                      │
└──────────────────────────────────────────────────────┘
```

### Trio Refinement

```
     PM ←────────────────────→ Designer
      │      co-criacao          │
      │                          │
      └──────── Tech Lead ───────┘

  PM: valida negocio e metricas
  Designer: valida UX e usabilidade
  Tech Lead: valida viabilidade tecnica
```

---

## Fase 7 — Delivery (Observer Mode)

> **Pergunta-chave**: "O que esta sendo entregue? Qual o ritmo?"

### Skill

| Comando | O que faz |
|---------|-----------|
| `/delivery-tracker` | Sprint dashboard, suggestion, review, ship item |

### Funcoes do delivery-tracker

```
/delivery-tracker dashboard       ← ver sprint atual
/delivery-tracker suggestion      ← sugestao de composicao de sprint
/delivery-tracker review          ← sprint review
/delivery-tracker ship OPP-XXX    ← marcar item como shipped
/delivery-tracker velocity        ← metricas de velocity
```

### Observer Mode — O que significa

```
┌──────────────────────────────────────────────┐
│  Product OS NAO gerencia sprints.            │
│  PM e devs continuam usando GitHub.          │
│                                              │
│  Product OS:                                 │
│    ✓ Sugere composicao de sprint             │
│    ✓ Le dados do GitHub Issues/Projects      │
│    ✓ Apresenta dashboards e metricas         │
│    ✓ Rastreia velocity e cycle time          │
│    ✗ NAO move issues                         │
│    ✗ NAO cria branches                       │
│    ✗ NAO fecha sprints                       │
└──────────────────────────────────────────────┘
```

### Ship Item — Cascata de Lifecycle

```
/delivery-tracker ship OPP-2026-015
         │
         ▼ atualiza automaticamente:
    Roadmap      → status: done, shippedDate: hoje
    Backlog      → status: shipped
    Ideation     → status: shipped
    OST          → solucao: shipped
         │
         ▼ sugere:
    /gtm-feedback-loop create    ← criar launch doc
```

---

## Fase 8 — GTM & Feedback Loop

> **Pergunta-chave**: "A feature entregue esta funcionando? O que decidir?"

### Skill

| Comando | O que faz |
|---------|-----------|
| `/gtm-feedback-loop` | Launch doc, checklist, reviews, changelogs |

### Agents

| Agent | Modelo | Quando usar |
|-------|--------|-------------|
| `post-launch-analyzer` | Sonnet | Coletar dados Pendo para D+30/D+90 |
| `launch-readiness-checker` | Haiku | Verificar readiness pre-launch |

### Checklist de Lancamento

```
D-3  ┌──────────────────────────────────────┐
     │ Treinar CS, battlecard, FAQ, docs    │
     └──────────────────────────────────────┘
D-1  ┌──────────────────────────────────────┐
     │ Release notes, comunicar CS/Vendas   │
     └──────────────────────────────────────┘
D+0  ┌──────────────────────────────────────┐
     │ Feature flag ON, monitoramento       │ ← LANCAMENTO
     └──────────────────────────────────────┘
D+7  ┌──────────────────────────────────────┐
     │ Tech review: erros, performance      │
     └──────────────────────────────────────┘
D+30 ┌──────────────────────────────────────┐
     │ ADOPTION REVIEW                      │
     │ Adocao %, metricas vs target         │ ← post-launch-analyzer
     └──────────────────────────────────────┘
D+90 ┌──────────────────────────────────────┐
     │ IMPACT REVIEW                        │
     │ Retencao, NPS, ROI, decisao final    │ ← post-launch-analyzer
     └──────────────────────────────────────┘
```

### Decisoes do Feedback Loop

```
                  D+90 Review
                      │
        ┌─────────────┼─────────────┬──────────────┐
        ▼             ▼             ▼              ▼
   ┌─────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐
   │ ITERATE │  │  SCALE   │  │ DISABLE  │  │ MAINTAIN │
   │         │  │          │  │          │  │          │
   │ Adocao  │  │ Adocao   │  │ Impacto  │  │ Adocao   │
   │ abaixo  │  │ no alvo  │  │ negativo │  │ OK, sem  │
   │ do alvo │  │ metricas │  │ guardrail│  │ acao     │
   │ sinais  │  │ positivas│  │ violado  │  │ adicional│
   │ posit.  │  │          │  │          │  │          │
   │         │  │ EXPANDIR │  │ REVERTER │  │          │
   │ REFINAR │  │          │  │          │  │          │
   └─────────┘  └──────────┘  └──────────┘  └──────────┘
```

---

## Inteligencia de Mercado (transversal)

| Comando | O que faz |
|---------|-----------|
| `/feature-benchmark` | Comparacao feature-a-feature com concorrentes |
| `/pricing-benchmark` | Pricing, packaging, posicionamento |
| `/trend-report` | Tendencias CRM/SalesTech |

| Agent | Modelo | Quando usar |
|-------|--------|-------------|
| `competitor-monitor` | Sonnet | Monitorar mudancas em concorrentes |
| `trend-scanner` | Sonnet | Varrer tendencias de mercado |

### Concorrentes Monitorados

```
Consolidados:  Pipedrive | RD Station CRM | HubSpot CRM | Ploomes
Emergentes:    Nectar CRM | Moskit CRM | Agendor | Fleeg
```

---

## 4 Dashboards Executivos

Para uma visao 360 do produto, execute na sequencia:

```
┌─────────────────────────────────────────────────────────────┐
│                                                              │
│  1. /monitoring-snapshot        Fase 1 — Metricas + Bugs    │
│  2. /discovery-cadence-report   Fase 2 — Discovery          │
│  3. /triage-dashboard           Fase 3 — Pipeline + SLA     │
│  4. /strategy-dashboard         Fases 4-8 — Estrategia      │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Cenarios Comuns — Quick Reference

### "Recebi uma demanda"
```
/opportunity-intake
→ descreva a demanda em texto livre
→ demand-router classifica automaticamente
→ Fast Lane (GitHub Issue) ou Discovery Lane (backlog)
```

### "Preciso preparar uma entrevista"
```
/discovery-prep conta=NomeDaConta
→ briefing com dados de uso, tickets, historico
```

### "Qual o NPS atual?"
```
/nps-analysis
→ score, evolucao, promotores vs detratores
(para analise profunda: nps-deep-dive agent)
```

### "Tenho uma ideia de feature"
```
/ideation-log create
→ registrar ideia conectada ao OST
→ se Confidence < 60%: /bet-test-manager
→ se Confidence >= 60%: /conception-manager
```

### "Feature foi entregue, e agora?"
```
/delivery-tracker ship OPP-2026-XXX
→ cascata de lifecycle atualizada
→ /gtm-feedback-loop create
→ checklist D-3 a D+90
```

### "Quero o resumo da semana"
```
/monitoring-snapshot
→ consolida uso, NPS, bugs, churn, sentimento
```

### "Preciso priorizar o backlog"
```
/rice-scorer                      ← calcular RICE com dados Pendo
/strategy-dashboard               ← ver ranking por Strategic Priority
/roadmap-planner                  ← alocar nos 3 horizontes
```

---

## Mapa de Storage

```
reports/
├── discovery/
│   ├── panel.json                    ← painel de clientes
│   └── touchpoint-YYYY-MM-DD-*.md   ← touchpoints
├── backlog/
│   ├── opportunity-index.json        ← indice do backlog
│   ├── opportunities/                ← OPP-YYYY-NNN-slug.md
│   └── archive/                      ← rejeitadas/mergeadas
└── strategy/
    ├── okrs/                         ← okrs-YYYY-QN.md
    ├── ost/                          ← ost-index.json + nodes
    ├── ideation/                     ← idea-YYYY-NNN-slug.md
    ├── roadmap/                      ← roadmap-current.json
    ├── validation/                   ← bet-YYYY-NNN-slug.md
    ├── conception/                   ← prd/onepager-YYYY-NNN.md
    └── delivery/
        ├── delivery-index.json       ← indice de launches
        ├── launches/                 ← launch-YYYY-NNN-slug.md
        ├── reviews/                  ← review-YYYY-NNN-d30/d90.md
        ├── changelogs/               ← interno semanal + externo mensal
        └── sprints/                  ← sprint-review-YYYY-SNN.md
```

---

## Hooks Automaticos

O sistema valida automaticamente ao escrever arquivos e ao encerrar sessoes:

| Quando | O que valida |
|--------|-------------|
| **Escrever em** `reports/discovery/touchpoint-*` | 4 campos obrigatorios + comportamento vs opiniao |
| **Escrever em** `reports/backlog/opportunities/*` | Frontmatter YAML (id, type, source, module...) |
| **Escrever em** `reports/strategy/okrs/*` | Quarter, status, objetivos, KRs |
| **Escrever em** `reports/strategy/validation/*` | Hipotese "Cremos que...", assumptions |
| **Escrever em** `reports/strategy/conception/*` | Level, secoes obrigatorias (PRD vs one-pager) |
| **Escrever em** `reports/strategy/delivery/launches/*` | ID, status, rollout, checklist |
| **Ao encerrar sessao** | Cadencia discovery, SLA P0/P1, reviews pendentes |

---

## Cadencias Recomendadas

| Frequencia | Acao | Skill/Agent |
|-----------|------|-------------|
| **Diaria** | Verificar bugs P0/P1 | `/bug-sla-check` |
| **2x/semana** | Processar demandas | `/opportunity-intake` |
| **Semanal** | Resumo executivo | `/monitoring-snapshot` |
| **Semanal** | Sessao de ideacao | `/ideation-log` |
| **Semanal** | Touchpoint discovery | `/discovery-touchpoint-log` |
| **Quinzenal** | Sprint review | `/delivery-tracker review` |
| **Quinzenal** | Atualizar roadmap | `/roadmap-planner` |
| **Mensal** | Check-in OKR | `/okr-manager check-in` |
| **Mensal** | Review OST | `/ost-builder review` |
| **Mensal** | Changelog externo | `/gtm-feedback-loop changelog` |
| **Trimestral** | Planning OKR + Roadmap | `/okr-manager create` + `/roadmap-planner` |
| **D+30/D+90** | Adoption/Impact review | `/gtm-feedback-loop review` |
