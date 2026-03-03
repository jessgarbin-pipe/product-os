---
name: conception-manager
description: "Gerencia a Fase 6 de Concepcao do Piperun: cria PRDs completos, one-pagers e issues estruturadas a partir de ideias validadas. Selecao automatica de nivel, template PRD com 8 elementos obrigatorios, trio refinement com checklist/notas/subissues, plano de rollout com 7 tipos, geracao de subissues como GitHub Issues, e promocao para delivery. Use SEMPRE que o usuario mencionar: criar PRD, concepcao, one-pager, detalhar feature, trio refinement, sessao de trio, subissues, work breakdown, rollout plan, promover para delivery, pipeline de concepcao, documento de concepcao, spec, requisitos detalhados, ou qualquer variacao."
---

# Gestao de Concepcao — Piperun

Skill para criar e gerenciar documentos de concepcao (PRD, one-pager, issue estruturada) na Fase 6 do Product OS. Ponte entre ideias validadas (Fase 5) e delivery/desenvolvimento (Fase 7).

## Conceito

A Fase 6 transforma insights e oportunidades validadas em documentacao estruturada pronta para execucao:

```
Fase 5 (Validacao)               Fase 6 (Concepcao)              Fase 7 (Delivery)
========================          ========================        ========================
bet-test (passed) ──────────────> PRD / One-pager / Issue ──────> GitHub Issue enriquecida
ideation-log (accepted, C>=60%) ─> Trio co-criacao (PM+Des+TL) ──> Subissues por disciplina
ost-builder (validada) ──────────> Rollout plan (7 tipos) ──────> Execucao
roadmap (committed) ─────────────> Work breakdown (epics) ──────> Development
```

### Niveis de Documentacao

| Nivel | Quando usar | Conteudo |
|-------|------------|----------|
| **PRD completo** | Iniciativas grandes, novas areas de produto, alto risco | Problema, JTBD, referencias, objetivo, epics, metricas, dependencias, spec |
| **One-pager** | Features e melhorias medias | Problema, solucao proposta, metricas de sucesso, estimativa |
| **Issue estruturada** | Melhorias pequenas e bugs | Contexto, criterios de aceite, screenshots/videos |

## Fontes de Dados

| Fonte | Localizacao | O que alimenta |
|-------|-------------|---------------|
| Ideacao | `reports/strategy/ideation/ideation-index.json` | Ideias aceitas/validadas |
| Backlog | `reports/backlog/opportunity-index.json` | Oportunidades referenciadas |
| Validacao | `reports/strategy/validation/validation-index.json` | Bet tests associados |
| OST | `reports/strategy/ost/ost-index.json` | Solucoes e objetivos |
| OKRs | `reports/strategy/okrs/okrs-*.md` | Alinhamento estrategico |
| Discovery | `reports/discovery/touchpoint-*.md` | Evidencias e JTBD |
| Pendo | MCP tools | Metricas baseline |
| Conception | `reports/strategy/conception/conception-index.json` | Index de docs |

## Storage

### Index: `reports/strategy/conception/conception-index.json`

```json
{
  "version": "1.0",
  "lastUpdated": "2026-03-15",
  "nextPrdId": 1,
  "nextOnepagerId": 1,
  "docs": [
    {
      "id": "PRD-2026-001",
      "title": "Titulo",
      "level": "prd",
      "status": "draft",
      "ideaRef": "IDEA-2026-001",
      "opportunityRef": "OPP-2026-005",
      "betTestRef": "BET-2026-001",
      "module": "pipeline",
      "trioComplete": false,
      "rolloutType": null,
      "created": "2026-03-15",
      "file": "prd-2026-001-slug.md"
    }
  ]
}
```

### Arquivo PRD: `reports/strategy/conception/prd-YYYY-NNN-slug.md`

**Frontmatter**:
```yaml
---
id: "PRD-2026-001"
title: "Titulo da iniciativa"
level: prd
status: draft | trio-review | ready | promoted
idea_ref: "IDEA-2026-001"
opportunity_ref: "OPP-2026-005"
bet_test_ref: "BET-2026-001"
ost_objective: "slug-do-objetivo"
module: "pipeline"
rollout_type: null | direto | gradual-rapido | gradual-controlado | segmentado | beta-direcionado | experimento | big-bang
trio_complete: false
created: "2026-03-15"
updated: "2026-03-15"
author: "PM"
---
```

### Arquivo One-pager: `reports/strategy/conception/onepager-YYYY-NNN-slug.md`

Mesma estrutura de frontmatter, com `level: onepager` e `id: "OP-2026-001"`.

## Lifecycle de Documentos

| Status | Significado | Proximo passo |
|--------|------------|--------------|
| `draft` | Documento criado, secoes sendo preenchidas | PM completa secoes (pode usar prd-enricher) |
| `trio-review` | Documento pronto, trio revisa e co-cria | Trio preenche checklist, notas, subissues |
| `ready` | Trio completou, documento pronto para delivery | PM promove para delivery-backlog-sync |
| `promoted` | GitHub Issue(s) criada(s), documento entregue | Execucao na Fase 7 |

## Template PRD (corpo — 10 secoes)

```markdown
# PRD-YYYY-NNN — [Titulo]

## 1. Problema e Jobs to Be Done (JTBD)

### Problema
[Descricao clara do problema que estamos resolvendo]

### JTBD
**Quando** [situacao/contexto], **eu quero** [motivacao/acao], **para que** [resultado esperado].

### Evidencias
| Fonte | Evidencia | Data |
|-------|----------|------|
| [touchpoint/Pendo/NPS/CS] | [citacao ou dado] | [data] |

### Segmentos afetados
- [Segmento 1]: [impacto]
- [Segmento 2]: [impacto]

---

## 2. Analise de Impacto (Monitoramento)

### Metricas baseline
| Metrica | Valor atual | Fonte |
|---------|------------|-------|
| [metrica] | [valor] | [Pendo/Metabase] |

### Reach
- Usuarios afetados: [N] ([X%] da base)
- Contas afetadas: [N]

### RICE Score
- Reach: [X] | Impact: [X] | Confidence: [X] | Effort: [X]
- **RICE**: [score]
- **Strategic Priority**: [score] (OKR Alignment: [1-5])

### Custo de nao fazer
[O que acontece se nao resolvermos este problema]

---

## 3. Referencias de Mercado

### Como concorrentes resolvem
| Concorrente | Abordagem | Diferencial |
|-------------|----------|-------------|
| [nome] | [como resolve] | [diferencial vs Piperun] |

### Tendencias relevantes
- [Tendencia 1]: [relevancia]

### Oportunidade de diferenciacao
[Como Piperun pode resolver melhor que o mercado]

---

## 4. Objetivo e Valor Esperado

### Objetivo
[O que queremos alcançar com esta iniciativa]

### Beneficios esperados
1. [Beneficio 1]: [quantificacao se possivel]
2. [Beneficio 2]: [quantificacao]

### Valor para o usuario
[Como o usuario se beneficia]

### Valor para o negocio
[Como o Piperun se beneficia — retencao, expansao, NPS, etc.]

---

## 5. Proposta de Solucao e Work Breakdown

### Visao geral
[Descricao da solucao proposta em alto nivel]

### Epics
| # | Epic | Descricao | Estimativa | Prioridade |
|---|------|----------|-----------|-----------|
| 1 | [epic] | [descricao] | [T-shirt] | Must-have |
| 2 | [epic] | [descricao] | [T-shirt] | Should-have |
| 3 | [epic] | [descricao] | [T-shirt] | Nice-to-have |

### Fora de escopo
- [Item 1]: [motivo de exclusao]
- [Item 2]: [motivo]

---

## 6. Metricas

### Principais (North Star)
| Metrica | Target | Prazo | Fonte |
|---------|--------|-------|-------|
| [metrica] | [target] | [prazo] | [Pendo/Metabase] |

### Secundarias
| Metrica | Target | Fonte |
|---------|--------|-------|
| [metrica] | [target] | [fonte] |

### Guardrails (nao devem piorar)
| Metrica | Threshold | Acao se violado |
|---------|----------|----------------|
| [metrica] | [limite] | [acao] |

---

## 7. Dependencias e Impactos

### Dependencias tecnicas
| Dependencia | Tipo | Status | Impacto se bloqueada |
|-------------|------|--------|---------------------|
| [dep] | [tecnica/produto/externa] | [status] | [impacto] |

### Impactos em outros modulos
| Modulo | Impacto | Mitigacao |
|--------|---------|----------|
| [modulo] | [como e afetado] | [como mitigar] |

### Riscos
| Risco | Probabilidade | Impacto | Mitigacao |
|-------|-------------|---------|----------|
| [risco] | [alta/media/baixa] | [alto/medio/baixo] | [plano] |

---

## 8. Spec / Requisitos Detalhados

### Requisitos funcionais
| # | Requisito | Prioridade | Criterio de aceite |
|---|----------|-----------|-------------------|
| RF-01 | [requisito] | Must-have | [criterio] |
| RF-02 | [requisito] | Should-have | [criterio] |

### Requisitos nao-funcionais
| # | Requisito | Tipo | Criterio |
|---|----------|------|---------|
| RNF-01 | [requisito] | [performance/seguranca/acessibilidade] | [criterio] |

### User Stories
| # | Como... | Eu quero... | Para que... |
|---|---------|------------|------------|
| US-01 | [persona] | [acao] | [resultado] |

---

## 9. Refinamento em Trio

### Participantes
| Papel | Nome | Data |
|-------|------|------|
| PM | [nome] | [data] |
| Designer | [nome] | [data] |
| Tech Lead | [nome] | [data] |

### Checklist de Refinamento
- [ ] PM apresentou problema e JTBD
- [ ] Designer validou fluxo e UX
- [ ] Tech Lead validou viabilidade tecnica
- [ ] Trio alinhou escopo (must-have vs nice-to-have)
- [ ] Dependencias identificadas e plano definido
- [ ] Estimativas revisadas pelo trio
- [ ] Subissues definidas por disciplina
- [ ] Plano de rollout acordado

### Notas e Decisoes
| # | Decisao | Justificativa | Responsavel |
|---|---------|-------------|------------|
| 1 | [decisao] | [por que] | [quem] |

### Pontos em aberto
- [ ] [ponto 1]
- [ ] [ponto 2]

### Subissues
| # | Titulo | Disciplina | Estimativa | Dependencia | GitHub Issue |
|---|--------|-----------|-----------|------------|-------------|
| 1 | [titulo] | design | [T-shirt] | - | - |
| 2 | [titulo] | backend | [T-shirt] | #1 | - |
| 3 | [titulo] | frontend | [T-shirt] | #1, #2 | - |
| 4 | [titulo] | dados | [T-shirt] | - | - |
| 5 | [titulo] | spike | [T-shirt] | - | - |

---

## 10. Plano de Rollout

### Tipo selecionado
**[tipo]**: [descricao breve]

### Tipos disponiveis
| Tipo | Quando usar | Risco |
|------|------------|-------|
| Direto | Mudanca simples, baixo risco, sem dependencias | Baixo |
| Gradual rapido | Feature nova, medio risco, rollout em 1-2 semanas | Medio |
| Gradual controlado | Feature complexa, alto risco, rollout em 4-8 semanas | Alto |
| Segmentado | Feature para segmento especifico (plano, tamanho, regiao) | Medio |
| Beta direcionado | Validacao com grupo seleto antes de GA | Alto |
| Experimento | A/B test, feature flag, metricas de comparacao | Alto |
| Big bang (raro) | Mudanca estrutural que afeta todos simultaneamente | Muito alto |

### Plano detalhado
- **Fase 1**: [descricao] — [% usuarios] — [duracao]
- **Fase 2**: [descricao] — [% usuarios] — [duracao]
- **GA**: [criterios para general availability]

### Rollback
- **Trigger**: [quando reverter]
- **Procedimento**: [como reverter]
- **Responsavel**: [quem decide]

### Comunicacao
| Audiencia | Canal | Mensagem | Quando |
|----------|-------|---------|--------|
| [audiencia] | [canal] | [mensagem] | [timing] |
```

## Template One-pager (corpo — 6 secoes)

```markdown
# OP-YYYY-NNN — [Titulo]

## Problema

### Descricao
[Descricao concisa do problema]

### Evidencias
| Fonte | Evidencia |
|-------|----------|
| [fonte] | [dado/citacao] |

### RICE Score
- Reach: [X] | Impact: [X] | Confidence: [X] | Effort: [X]
- **RICE**: [score] | **Strategic Priority**: [score]

---

## Solucao Proposta

### Descricao
[O que sera construido/modificado]

### Escopo
| Incluido | Excluido |
|----------|---------|
| [item] | [item] |

---

## Metricas de Sucesso

| Tipo | Metrica | Target | Fonte |
|------|---------|--------|-------|
| Primaria | [metrica] | [target] | [fonte] |
| Secundaria | [metrica] | [target] | [fonte] |
| Guardrail | [metrica] | [threshold] | [fonte] |

---

## Estimativa e Dependencias

- **Effort**: [T-shirt: XS/S/M/L/XL]
- **Estimativa**: [semanas]
- **Dependencias**: [lista]
- **Riscos**: [lista]

---

## Refinamento em Trio

### Participantes
| Papel | Nome | Data |
|-------|------|------|
| PM | [nome] | [data] |
| Designer | [nome] | [data] |
| Tech Lead | [nome] | [data] |

### Checklist
- [ ] PM apresentou problema
- [ ] Designer validou UX
- [ ] Tech Lead validou viabilidade
- [ ] Escopo alinhado
- [ ] Subissues definidas

### Notas
| # | Decisao | Responsavel |
|---|---------|------------|
| 1 | [decisao] | [quem] |

### Subissues
| # | Titulo | Disciplina | Estimativa | GitHub Issue |
|---|--------|-----------|-----------|-------------|
| 1 | [titulo] | [tipo] | [T-shirt] | - |

---

## Plano de Rollout

- **Tipo**: [direto | gradual-rapido | gradual-controlado | segmentado | beta-direcionado | experimento | big-bang]
- **Detalhes**: [descricao do plano]
- **Rollback**: [trigger e procedimento]
```

## Logica de Selecao Automatica de Nivel

| Tipo | Effort | Nivel sugerido |
|------|--------|---------------|
| Bug | qualquer | Issue estruturada |
| Tech-debt | qualquer | Issue estruturada |
| Improvement | XS/S | Issue estruturada |
| Improvement | M | One-pager |
| Improvement | L/XL | PRD |
| Feature | XS/S | One-pager |
| Feature | M/L/XL | PRD |

**Overrides para cima**:
- Nova area de produto → PRD (independente do tipo/effort)
- RICE >= 8 ou Strategic Priority >= 10 → PRD
- PM pode sempre overridar o nivel sugerido

## Operacoes

### 1. Criar Documento de Concepcao
**Trigger**: "criar PRD para IDEA-X", "concepcao para OPP-X", "detalhar feature"

**Fluxo**:
1. PM indica ideia (IDEA-YYYY-NNN) e/ou oportunidade (OPP-YYYY-NNN)
2. Ler ideia completa em `reports/strategy/ideation/`
3. Ler oportunidade completa em `reports/backlog/opportunities/`
4. Ler bet test associado em `reports/strategy/validation/` (se existir)
5. **Gate check**: Confidence >= 60% ou bet test `passed`
   - Se nao atende: alertar PM — "Confidence [X]% sem bet test passed. Deseja prosseguir mesmo assim?"
   - PM pode overridar (gate flexivel) — registrar justificativa
6. Determinar nivel automaticamente (tabela acima), informar PM
   - PM pode overridar nivel sugerido
7. **Se issue estruturada**:
   - Montar template expandido com: JTBD, evidencias, RICE, solucao proposta, criterios de aceite, metricas, rollout
   - Delegar para `delivery-backlog-sync` com template enriquecido
   - FIM (nao cria arquivo em conception/)
8. **Se PRD ou one-pager**:
   - Perguntar ao PM se quer pre-preenchimento automatico via agent `prd-enricher` (sonnet, max 15 turns)
   - Se sim: invocar agent, usar JSON retornado para popular secoes
9. Gerar ID:
   - PRD: `PRD-YYYY-NNN` (baseado no nextPrdId do index, ano atual)
   - One-pager: `OP-YYYY-NNN` (baseado no nextOnepagerId do index, ano atual)
10. Gerar slug a partir do titulo (kebab-case, max 50 chars)
11. Criar arquivo com template preenchido:
    - PRD: `reports/strategy/conception/prd-YYYY-NNN-slug.md`
    - One-pager: `reports/strategy/conception/onepager-YYYY-NNN-slug.md`
12. Atualizar `conception-index.json`:
    - Adicionar doc ao array `docs`
    - Incrementar nextPrdId ou nextOnepagerId
    - Atualizar lastUpdated
13. Atualizar status em outros sistemas:
    - Ideia no `ideation-log`: status → `conceiving` (atualizar arquivo e ideation-index.json)
    - Solucao no OST: status → `em-concepcao` (se existir no OST)
    - Oportunidade no backlog: status → `in-conception`, campo `conception_ref` → ID do doc
14. Informar PM do documento criado com link

### 2. Atualizar Documento
**Trigger**: "atualizar PRD-X", "editar one-pager OP-X", "completar secao X do PRD"

**Fluxo**:
1. Ler documento em `reports/strategy/conception/`
2. PM indica secao e conteudo a atualizar
3. Atualizar secao no documento
4. Atualizar campo `updated` no frontmatter
5. Atualizar `conception-index.json` (lastUpdated)

### 3. Registrar Sessao de Trio
**Trigger**: "sessao de trio para PRD-X", "refinamento com trio", "trio review"

**Fluxo**:
1. Ler documento em `reports/strategy/conception/`
2. Se status é `draft` → atualizar para `trio-review`
3. PM fornece:
   - Participantes (PM, Designer, Tech Lead — nomes e data)
   - Notas e decisoes tomadas
   - Pontos em aberto
   - Subissues definidas (titulo, disciplina, estimativa, dependencias)
4. Atualizar secao "Refinamento em Trio" no documento
5. Verificar checklist:
   - Se todos os itens marcados: `trio_complete: true`
   - Se nao: manter `trio_complete: false`, informar itens pendentes
6. Atualizar frontmatter e index

### 4. Gerar Subissues
**Trigger**: "gerar subissues para PRD-X", "criar subissues", "criar issues do trio"

**Fluxo**:
1. Ler documento e extrair tabela de subissues
2. Para cada subissue na tabela:
   - Montar titulo: "[PRD-YYYY-NNN] [titulo da subissue]"
   - Montar body com contexto do PRD (link, epic, criterios)
   - Definir labels: `type:[disciplina]`, `mod:[modulo]`, `source:product-os`, `conception:[id-doc]`
   - Criar GitHub Issue via `gh issue create`
3. Registrar issue numbers na tabela de subissues do documento
4. Informar PM das issues criadas

### 5. Listar Documentos / Pipeline de Concepcao
**Trigger**: "ver concepcao", "pipeline de concepcao", "docs em andamento"

**Formato**:
```
# Pipeline de Concepcao — Piperun
**Data**: [data] | **Total**: [N] documentos

## Por Status
| Status | Quantidade |
|--------|-----------|
| draft | [N] |
| trio-review | [N] |
| ready | [N] |
| promoted | [N] |

## Por Nivel
| Nivel | Quantidade |
|-------|-----------|
| PRD | [N] |
| One-pager | [N] |

## Documentos em Progresso
| ID | Titulo | Nivel | Status | Modulo | Trio? | Idade | Alerta |
|----|--------|-------|--------|--------|-------|-------|--------|
| PRD-2026-001 | [titulo] | PRD | draft | pipeline | Nao | 5d | - |
| OP-2026-001 | [titulo] | One-pager | trio-review | relatorios | Parcial | 12d | Trio >7d |

## Alertas
- PRD-2026-001: draft ha [N] dias (alerta >7d)
- OP-2026-001: trio-review ha [N] dias (alerta >14d)
```

### 6. Promover para Delivery
**Trigger**: "promover PRD-X para delivery", "enviar para desenvolvimento"

**Fluxo**:
1. Ler documento em `reports/strategy/conception/`
2. Verificar status `ready` (trio completou):
   - Se nao é `ready`: alertar PM que trio nao completou, perguntar se deseja overridar
3. Montar GitHub Issue master com template enriquecido:
   ```markdown
   ## [Titulo da Iniciativa]

   ### JTBD
   [Extraido do PRD/one-pager]

   ### Evidencias
   [Resumo das evidencias]

   ### RICE / Strategic Priority
   [Scores extraidos]

   ### Metricas de Sucesso
   | Tipo | Metrica | Target |
   |------|---------|--------|
   | Primaria | [metrica] | [target] |
   | Guardrail | [metrica] | [threshold] |

   ### Rollout
   - **Tipo**: [tipo]
   - **Plano**: [resumo]

   ### Documento de Concepcao
   [Link para PRD/one-pager no repositorio]

   ### Subissues
   [Lista de subissues com links]

   ---
   _Criado via Product OS — Conception Manager (Fase 6)_
   ```
4. Criar issue via `delivery-backlog-sync` ou `gh issue create`
5. Atualizar status do documento para `promoted`
6. Atualizar outros sistemas:
   - Ideia no `ideation-log`: status → `shipped`
   - Solucao no OST: status → `em-progresso`
   - Oportunidade no backlog: status → `promoted`
   - Roadmap: registrar `conceptionRef` no item (se existir)
7. Atualizar `conception-index.json`
8. Informar PM com link da Issue master

### 7. Concepcao Check (automatico)
**Trigger**: quando `delivery-backlog-sync` e invocado para feature/improvement com effort >= M sem doc de concepcao

**Fluxo**:
1. Verificar se oportunidade tem `conception_ref` no backlog
2. Se nao tem e tipo é feature/improvement com effort >= M:
   - Alertar PM: "Esta oportunidade nao tem documento de concepcao. Para features/melhorias M+ recomenda-se criar PRD ou one-pager via /conception-manager."
   - PM pode prosseguir sem (gate flexivel)

## Tipos de Rollout

| Tipo | Quando usar | Risco | Exemplo |
|------|------------|-------|---------|
| **Direto** | Mudanca simples, baixo risco, sem dependencias | Baixo | Bug fix, melhoria UI pontual |
| **Gradual rapido** | Feature nova, medio risco, rollout em 1-2 semanas | Medio | Nova opcao de filtro |
| **Gradual controlado** | Feature complexa, alto risco, rollout em 4-8 semanas | Alto | Novo modulo completo |
| **Segmentado** | Feature para segmento especifico (plano, tamanho, regiao) | Medio | Feature enterprise-only |
| **Beta direcionado** | Validacao com grupo seleto antes de GA | Alto | Redesign de interface critica |
| **Experimento** | A/B test, feature flag, metricas de comparacao | Alto | Novo fluxo de onboarding |
| **Big bang** (raro) | Mudanca estrutural que afeta todos simultaneamente | Muito alto | Migracao de banco, mudanca de arquitetura |

## Integracao com Outras Skills

| Skill/Agent | Direcao | Dados |
|-------------|---------|-------|
| `ideation-log` | → conception | Ideias aceitas/validadas sao input para concepcao |
| `ideation-log` | ← conception | Status atualizado para "conceiving" durante concepcao |
| `bet-test-manager` | → conception | Bet tests passed validam ideias para concepcao |
| `ost-builder` | ← conception | Solucao atualizada para "em-concepcao" |
| `opportunity-backlog-manager` | ← conception | Oportunidade atualizada para "in-conception" |
| `delivery-backlog-sync` | ← conception | Template enriquecido + label `conception:prd/onepager/issue` |
| `rice-scorer` | → conception | RICE score para secao de impacto |
| `roadmap-planner` | ← conception | Campo `conceptionRef` no item do roadmap |
| `prd-enricher` | → conception | Agent coleta dados para pre-preencher PRD/one-pager |
| `feature-benchmark` | → conception | Referencias de mercado para secao 3 |
| `usage-monitor` | → conception | Metricas baseline para secao 2 |
| `discovery-touchpoint-log` | → conception | Evidencias e JTBD para secoes 1 e 2 |
| `strategy-dashboard` | ← conception | Secao 6 — Conception Pipeline |
| `okr-manager` | → conception | Alinhamento estrategico para PRD |

## Observacoes

- PRD/one-pager nao e "um documento que o PM escreve sozinho" — o trio co-cria a solucao desde o inicio
- Designer e Dev nao "revisam" a demanda — eles co-criam a solucao
- Gate de Confidence é flexivel — PM pode overridar, mas deve justificar
- Issue estruturada nao cria arquivo em conception/ — vai direto para delivery-backlog-sync
- Pre-preenchimento via prd-enricher é opcional mas recomendado para PRDs
- Subissues devem cobrir todas as disciplinas: design, backend, frontend, dados, spikes, discovery
- Plano de rollout deve ser definido na concepcao, nao ad hoc no momento do lancamento
- Hook `validate-conception-doc.sh` valida campos obrigatorios
- Hook `strategy-review-reminder.sh` alerta docs draft >7d, trio-review >14d, ready >7d
