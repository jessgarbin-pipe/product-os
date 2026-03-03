---
name: gtm-feedback-loop
description: "Gerencia o ciclo pos-delivery do Piperun: checklist de lancamento (D-3 a D+90), reviews estruturados D+30 (adocao) e D+90 (impacto), decisoes de feedback loop (iterate/scale/disable/maintain), changelogs internos e externos, briefings PAB e pipeline de lancamentos. Use SEMPRE que o usuario mencionar: launch, lancamento, go-to-market, GTM, release notes, changelog, D+30, D+90, adoption review, impact review, feedback loop, PAB, post-launch, pipeline de lancamentos, criar launch, decisao de feedback, checklist de lancamento, ou qualquer variacao."
---

# Go-to-Market & Feedback Loop — Piperun

Skill para gerenciar o ciclo pos-delivery: checklist de lancamento (D-3 a D+90), reviews estruturados, decisoes de feedback loop, changelogs e comunicacao. Fecha o ciclo de produto com dados reais de uso.

## Conceito

```
Fase 7 (Delivery)              Fase 8 (GTM & Feedback)
========================       ========================
Ship item (shipped) ──────────> Launch doc (D-3..D+90)
Deploy + rollout exec ────────> Release notes + Pendo guide
                               D+7 tech review
                               D+30 adoption review (agent)
                               D+90 impact review (agent)
                               Decision: iterate/scale/disable/maintain
                               Changelog + PAB briefing
                               OST update com resultado real
```

## Fontes de Dados

| Fonte | Localizacao | O que alimenta |
|-------|-------------|---------------|
| Delivery Index | `reports/strategy/delivery/delivery-index.json` | Launches index |
| Launch Docs | `reports/strategy/delivery/launches/*.md` | Launch details |
| Reviews | `reports/strategy/delivery/reviews/*.md` | D+30/D+90 reviews |
| Changelogs | `reports/strategy/delivery/changelogs/*.md` | Internal/external changelogs |
| Roadmap | `reports/strategy/roadmap/roadmap-current.json` | Item shipped |
| Conception | `reports/strategy/conception/conception-index.json` | PRD/one-pager source |
| Pendo | MCP tools | Adoption, usage, frustration metrics |
| Backlog | `reports/backlog/opportunity-index.json` | Oportunidade ref |
| Ideacao | `reports/strategy/ideation/ideation-index.json` | Ideia ref |
| OST | `reports/strategy/ost/ost-index.json` | Solucao ref |

## Storage

```
reports/strategy/delivery/
├── delivery-index.json
├── launches/
│   └── launch-YYYY-NNN-slug.md
├── reviews/
│   ├── review-YYYY-NNN-d30.md
│   └── review-YYYY-NNN-d90.md
├── changelogs/
│   ├── changelog-internal-YYYY-WNN.md
│   └── changelog-external-YYYY-MM.md
└── sprints/
    └── sprint-review-YYYY-SNN.md
```

### Index: `reports/strategy/delivery/delivery-index.json`

```json
{
  "version": "1.0",
  "lastUpdated": "2026-03-15",
  "nextLaunchId": 1,
  "launches": [
    {
      "id": "LAUNCH-2026-001",
      "title": "Titulo",
      "status": "preparing",
      "conceptionRef": "PRD-2026-001",
      "roadmapRef": "RM-001",
      "rolloutType": "gradual-rapido",
      "module": "pipeline",
      "launchedDate": null,
      "d30ReviewDate": null,
      "d90ReviewDate": null,
      "decision": null,
      "created": "2026-03-15",
      "file": "launch-2026-001-slug.md"
    }
  ]
}
```

## Lifecycle de Lancamentos

| Status | Significado | Proximo passo |
|--------|------------|--------------|
| `preparing` | Checklist D-3 a D-1 em andamento | Completar preparacao |
| `launched` | Feature live (D+0) | Monitorar, esperar D+7 |
| `monitoring` | Pos-lancamento, coletando dados | Esperar D+30 |
| `reviewing-d30` | Adoption review em andamento | Completar review |
| `reviewing-d90` | Impact review em andamento | Tomar decisao |
| `decided` | Decisao tomada (iterate/scale/disable/maintain) | Executar decisao |
| `closed` | Ciclo completo, learnings registrados | Arquivo |

## Frontmatter do Launch Doc

```yaml
---
id: "LAUNCH-2026-001"
title: "Titulo do lancamento"
status: preparing | launched | monitoring | reviewing-d30 | reviewing-d90 | decided | closed
conception_ref: "PRD-2026-001"
roadmap_ref: "RM-001"
opportunity_ref: "OPP-2026-005"
rollout_type: "gradual-rapido"
module: "pipeline"
launched_date: null
d30_review_date: null
d90_review_date: null
decision: null | iterate | scale | disable | maintain
created: "2026-03-15"
updated: "2026-03-15"
---
```

## Template do Launch Doc (corpo — 7 secoes)

```markdown
# LAUNCH-YYYY-NNN — [Titulo]

## 1. Contexto
- **O que**: [descricao da feature/melhoria]
- **JTBD**: [extraido do PRD/one-pager]
- **Rollout**: [tipo] — [descricao do plano]
- **Metricas planejadas**: [do PRD]
- **Guardrails**: [do PRD]
- **Docs**: [links para PRD, GitHub Issues]

## 2. Checklist de Lancamento
### D-3: Preparacao
- [ ] CS treinado no novo fluxo
- [ ] Battlecard criado (se aplicavel)
- [ ] FAQ preparado para suporte
- [ ] Documentacao atualizada

### D-1: Comunicacao
- [ ] Release notes internos prontos
- [ ] Comunicacao para CS/Vendas enviada
- [ ] Pendo guide configurado (se aplicavel)

### D+0: Launch
- [ ] Feature flag ativada (conforme rollout plan)
- [ ] Release notes publicados
- [ ] Pendo guide ativo
- [ ] Monitoramento de erros configurado

### D+7: Tech Review
- [ ] Erros de producao verificados
- [ ] Performance dentro dos limites
- [ ] Rollback nao necessario
- [ ] Proxima fase de rollout liberada (se gradual)

## 3. Monitoramento Pos-Launch
| Metrica | Baseline | D+7 | D+14 | D+30 | Target |
|---------|----------|-----|------|------|--------|
| [metrica primaria] | [valor] | - | - | - | [target] |
| [guardrail] | [valor] | - | - | - | [threshold] |

## 4. D+30 Adoption Review
**Data**: [data] | **Status**: [pendente/concluido]
[Preenchido durante review — link para review doc se existir]

## 5. D+90 Impact Review
**Data**: [data] | **Status**: [pendente/concluido]
[Preenchido durante review — link para review doc se existir]

## 6. Decisao de Feedback Loop
**Decisao**: [iterate | scale | disable | maintain]
**Justificativa**: [baseada nos dados de D+30/D+90]
**Acoes**: [lista de acoes decorrentes]

## 7. Learnings
| # | Learning | Acao | Status |
|---|---------|------|--------|
| 1 | [o que aprendemos] | [o que fazer diferente] | [pendente/feito] |
```

## Operacoes

### 1. Criar Launch Doc
**Trigger**: "criar launch para RM-001", "preparar lancamento", "GTM para PRD-X"

**Fluxo**:
1. PM indica item do roadmap (RM-NNN) ou conception doc (PRD-NNN/OP-NNN)
2. Ler item no roadmap em `reports/strategy/roadmap/roadmap-current.json`
3. Ler conception doc associado em `reports/strategy/conception/`
4. Extrair: titulo, JTBD, metricas planejadas, rollout plan, guardrails
5. Gerar ID: `LAUNCH-YYYY-NNN` (baseado no nextLaunchId do index, ano atual)
6. Gerar slug a partir do titulo (kebab-case, max 50 chars)
7. Criar launch doc com template preenchido em `reports/strategy/delivery/launches/`
8. Atualizar `delivery-index.json`:
   - Adicionar launch ao array `launches`
   - Incrementar `nextLaunchId`
   - Atualizar `lastUpdated`
9. Atualizar roadmap item: `launchRef` → LAUNCH-YYYY-NNN
10. Opcionalmente invocar agent `launch-readiness-checker` para verificar readiness
11. Informar PM do launch doc criado

### 2. Atualizar Checklist
**Trigger**: "marcar D-3 como done", "atualizar checklist do launch", "D+0 completo"

**Fluxo**:
1. PM indica launch (LAUNCH-YYYY-NNN) e items a marcar
2. Ler launch doc
3. Atualizar checkboxes (- [ ] → - [x])
4. Se todos os items de D-3 + D-1 completos e status `preparing`: sugerir mudar para `launched`
5. Se D+7 completo e status `launched`: mudar para `monitoring`
6. Atualizar `updated` no frontmatter
7. Atualizar delivery-index.json se status mudou

### 3. Gerar Release Notes
**Trigger**: "release notes para LAUNCH-X", "gerar release notes"

**Fluxo**:
1. Ler launch doc e conception doc associado
2. Gerar release notes em dois formatos:

**Formato Interno**:
```markdown
# Release Notes (Interno) — [Titulo]
**Data**: [data] | **Launch**: LAUNCH-YYYY-NNN

## O que mudou
[Descricao tecnica e de produto]

## Como funciona
[Passo a passo para CS/Vendas]

## FAQ
- **P**: [pergunta comum]
- **R**: [resposta]

## Impacto esperado
[Metricas planejadas]

## Rollout
- **Tipo**: [tipo]
- **Status**: [fase atual]
```

**Formato Externo (user-facing)**:
```markdown
# [Titulo amigavel]

[Descricao curta e empolgante do beneficio]

## Como usar
[Passo a passo simples para o usuario final]

## Detalhes
[Informacoes adicionais se necessario]
```

### 4. Adoption Review (D+30)
**Trigger**: "D+30 para LAUNCH-X", "adoption review"

**Fluxo**:
1. Ler launch doc para obter metricas planejadas e refs
2. Invocar agent `post-launch-analyzer` (sonnet, max 20 turns) com:
   - Launch ID
   - Feature/page IDs do Pendo
   - Metricas planejadas e guardrails
   - Periodo: launchedDate → launchedDate + 30d
3. Gerar review doc em `reports/strategy/delivery/reviews/review-YYYY-NNN-d30.md`
4. Atualizar launch doc secao 4 com link para review
5. Atualizar launch status → `reviewing-d30`
6. Atualizar delivery-index.json: `d30ReviewDate` → hoje

**Template D+30**:
```yaml
---
launch_ref: "LAUNCH-2026-001"
review_type: d30
review_date: "2026-04-15"
created: "2026-04-15"
---
```

```markdown
# D+30 Adoption Review — LAUNCH-YYYY-NNN

## Adocao
- Usuarios usando a feature: [N] ([X%] da base)
- Contas usando a feature: [N] ([X%] da base)
- Frequencia media: [N] usos/semana

## Metricas vs Target
| Metrica | Baseline | Target | Atual (D+30) | Status |
|---------|----------|--------|-------------|--------|
| [metrica] | [baseline] | [target] | [atual] | [on-track/at-risk/off-track] |

## Guardrails
| Guardrail | Threshold | Valor Atual | Status |
|----------|----------|------------|--------|
| [guardrail] | [threshold] | [valor] | [OK/Violacao] |

## Frustration Metrics (Pendo)
| Metrica | Valor | Comparacao com media |
|---------|-------|---------------------|
| Rage clicks | [N] | [acima/normal/abaixo] |
| Dead clicks | [N] | [acima/normal/abaixo] |
| Error clicks | [N] | [acima/normal/abaixo] |

## Qualitativo
- NPS mentions: [resumo]
- CS feedback: [resumo]
- Support tickets: [N] relacionados

## Recomendacao
[Recomendacao baseada nos dados: continuar monitorando / iterar / escalar / atenção]
```

### 5. Impact Review (D+90)
**Trigger**: "D+90 para LAUNCH-X", "impact review", "business impact"

**Fluxo**:
1. Ler launch doc e D+30 review
2. Invocar agent `post-launch-analyzer` com periodo estendido (90 dias)
3. Gerar review doc em `reports/strategy/delivery/reviews/review-YYYY-NNN-d90.md`
4. Foco em impacto de negocio: retencao, expansao, NPS, ROI
5. Atualizar launch doc secao 5
6. Atualizar launch status → `reviewing-d90`
7. Atualizar delivery-index.json: `d90ReviewDate` → hoje

**Template D+90** (alem do D+30):
```markdown
# D+90 Impact Review — LAUNCH-YYYY-NNN

## Adocao (estabilizada)
[Mesma estrutura do D+30 com dados atualizados]

## Impacto de Negocio
| Dimensao | Antes | Depois | Delta |
|----------|-------|--------|-------|
| Retencao (contas com feature) | [X%] | [X%] | [+/-X pp] |
| Expansao (upsell/cross-sell) | [N] | [N] | [+/-N] |
| NPS (segmento afetado) | [N] | [N] | [+/-N] |

## ROI Estimado
- Investimento: [N] sprints / [N] story points
- Retorno estimado: [descricao qualitativa ou quantitativa]

## Decisao Recomendada
| Opcao | Quando | Recomendacao |
|-------|--------|-------------|
| **iterate** | Adocao abaixo do target, sinais positivos | [se aplica: detalhes] |
| **scale** | Adocao no target, metricas positivas | [se aplica: detalhes] |
| **disable** | Impacto negativo, guardrails violados | [se aplica: detalhes] |
| **maintain** | Adocao OK, sem acao adicional | [se aplica: detalhes] |

**Recomendacao**: [decisao recomendada com justificativa]
```

### 6. Feedback Loop Decision
**Trigger**: "decidir sobre LAUNCH-X", "feedback loop decision"

**Fluxo**:
1. Ler launch doc e reviews D+30/D+90
2. PM indica decisao: `iterate | scale | disable | maintain`
3. PM fornece justificativa e acoes decorrentes
4. Atualizar launch doc secao 6
5. Atualizar launch status → `decided`
6. Atualizar delivery-index.json: `decision` → valor escolhido
7. Atualizar lifecycles em cascata:
   a. **OST**: solucao status → `medida`, adicionar resultado real
   b. **Ideation-log**: ideia status → `measured`
   c. **Oportunidade no backlog**: status → `measured`
8. Se `iterate`: criar nova oportunidade no backlog com referencia ao launch
9. Se `disable`: registrar motivo e plano de rollback

### 7. Weekly Internal Changelog
**Trigger**: "changelog semanal", "changelog interno"

**Fluxo**:
1. Ler launches da semana em `delivery-index.json` (launchedDate na semana corrente)
2. Ler GitHub Issues fechadas na semana via `gh issue list --state closed`
3. Compilar changelog

**Formato**:
```markdown
# Changelog Interno — Semana [NN] ([data-inicio] a [data-fim])

## Lancamentos
| Launch | Titulo | Tipo | Status |
|--------|--------|------|--------|
| LAUNCH-... | [titulo] | [rollout type] | [status] |

## Correcoes e Melhorias
| Issue | Titulo | Tipo | Modulo |
|-------|--------|------|--------|
| #[N] | [titulo] | [tipo] | [modulo] |

## Em Desenvolvimento
| Issue | Titulo | Tipo | Sprint |
|-------|--------|------|--------|
| #[N] | [titulo] | [tipo] | S[N] |

## Metricas da Semana
- Issues fechadas: [N]
- Launches: [N]
- D+30 reviews: [N]
- D+90 reviews: [N]
```

Salva em `reports/strategy/delivery/changelogs/changelog-internal-YYYY-WNN.md`.

### 8. Monthly External Changelog
**Trigger**: "changelog externo", "changelog mensal", "what's new"

**Fluxo**:
1. Ler launches do mes em `delivery-index.json`
2. Para cada launch: ler titulo e descricao user-friendly
3. Compilar changelog externo

**Formato**:
```markdown
# What's New — [Mes YYYY]

## Novidades

### [Titulo amigavel 1]
[Descricao curta do beneficio para o usuario]

### [Titulo amigavel 2]
[Descricao curta do beneficio para o usuario]

## Melhorias
- [Melhoria 1]
- [Melhoria 2]

## Correcoes
- [Correcao 1]
- [Correcao 2]
```

Salva em `reports/strategy/delivery/changelogs/changelog-external-YYYY-MM.md`.

### 9. PAB Briefing
**Trigger**: "PAB briefing", "product advisory board"

**Fluxo**:
1. Ler launches recentes (ultimos 30 dias)
2. Ler roadmap committed (in-progress)
3. Ler roadmap planned (proximos no pipeline)
4. Compilar briefing

**Formato**:
```markdown
# PAB Briefing — [Data]

## Lancados Recentemente
| Feature | Data | Adocao (D+30) | Impacto |
|---------|------|-------------|---------|
| [titulo] | [data] | [X%] | [resumo] |

## Em Desenvolvimento
| Feature | Sprint | ETA | Status |
|---------|--------|-----|--------|
| [titulo] | S[N] | [data] | [status] |

## Proximos no Roadmap
| Feature | Horizonte | Quarter | Motivo |
|---------|-----------|---------|--------|
| [titulo] | planned | Q[N] | [alinhamento OKR] |

## Metricas de Produto
- NPS: [score] ([trend])
- Adocao media (features novas): [X%]
- Bugs P0/P1 abertos: [N]

## Para Discussao
1. [Topico 1]
2. [Topico 2]
```

### 10. Launch Pipeline
**Trigger**: "pipeline de lancamentos", "ver launches"

**Fluxo**:
1. Ler `delivery-index.json`
2. Agrupar launches por status
3. Identificar proxima acao pendente para cada launch

**Formato**:
```markdown
# Launch Pipeline — Piperun
**Data**: [data] | **Total**: [N] launches

## Por Status
| Status | Qtd |
|--------|-----|
| preparing | [N] |
| launched | [N] |
| monitoring | [N] |
| reviewing-d30 | [N] |
| reviewing-d90 | [N] |
| decided | [N] |
| closed | [N] |

## Launches Ativos
| ID | Titulo | Status | Modulo | Proxima Acao | Data Prevista |
|----|--------|--------|--------|-------------|--------------|
| LAUNCH-... | [titulo] | monitoring | [mod] | D+30 review | [data] |
| LAUNCH-... | [titulo] | preparing | [mod] | Completar D-3 | [data] |

## Reviews Pendentes
| Launch | Tipo | Data Prevista | Dias em Atraso |
|--------|------|-------------|---------------|
| LAUNCH-... | D+30 | [data] | [N] |
| LAUNCH-... | D+90 | [data] | [N] |

## Decisoes Recentes (ultimo mes)
| Launch | Decisao | Data | Impacto |
|--------|---------|------|---------|
| LAUNCH-... | scale | [data] | [resumo] |
```

## Integracao com Outras Skills

| Skill/Agent | Direcao | Dados |
|-------------|---------|-------|
| `delivery-tracker` | → GTM | Ship item sugere criar launch doc |
| `roadmap-planner` | → GTM | Items shipped alimentam launches |
| `conception-manager` | → GTM | PRD/one-pager fornecem JTBD, metricas, rollout |
| `ost-builder` | ← GTM | D+90 review atualiza solucao para `medida` com resultado real |
| `ideation-log` | ← GTM | Feedback loop decision atualiza ideia para `measured` |
| `opportunity-backlog-manager` | ← GTM | Feedback loop decision atualiza oportunidade para `measured` |
| `post-launch-analyzer` | → GTM | Agent coleta dados Pendo/Metabase para reviews |
| `launch-readiness-checker` | → GTM | Agent verifica readiness pre-launch |
| `strategy-dashboard` | ← GTM | Secao 9 — GTM Pipeline |
| `usage-monitor` | → GTM | Metricas de uso para reviews |
| `nps-analysis` | → GTM | NPS mentions para reviews |

## Observacoes

- Launch doc e o artefato central do ciclo GTM — contem checklist, metricas e decisao
- D+30 foca em **adocao** — usuarios estao usando? Frustration? Bugs?
- D+90 foca em **impacto de negocio** — retencao, NPS, ROI
- Decisao de feedback loop e sempre baseada em dados, nao intuicao
- `iterate` cria nova oportunidade no backlog — ciclo se repete
- `disable` requer plano de rollback e comunicacao
- Changelogs: interno semanal (para CS/Vendas), externo mensal (para usuarios)
- PAB briefing: quinzenal, preparado para Product Advisory Board
- Hook `validate-launch-doc.sh` valida campos obrigatorios do frontmatter
- Hook `strategy-review-reminder.sh` alerta D+30/D+90 pendentes e changelog atrasado
