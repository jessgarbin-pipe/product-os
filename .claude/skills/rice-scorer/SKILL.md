---
name: rice-scorer
description: "Calcula RICE score adaptado para o Piperun usando dados reais do Pendo (Reach, Impact parcial) e evidências de discovery (Impact, Confidence). Aplicável a Features e Melhorias no Opportunity Backlog. Use SEMPRE que o usuário mencionar: RICE, pontuar oportunidade, score da demanda, priorizar feature, ranking de oportunidades, calcular RICE, qual a prioridade, priorização, scoring, ou qualquer variação."
---

# RICE Scoring Adaptado — Piperun

Skill para calcular RICE score de oportunidades (Features e Melhorias) usando dados reais do Pendo + evidências de discovery.

## Fórmula RICE

```
RICE = (Reach × Impact × Confidence) / Effort
```

## Componentes

### Reach (R) — Quantas contas/visitors são afetados
**Fonte primária**: Pendo (`activityQuery`, `accountQuery`, `searchEntities`)

| Score | Critério | Como medir |
|-------|----------|-----------|
| 10 | >50% das contas ativas | Pendo: contas que usam feature/módulo relacionado |
| 7 | 30-50% das contas | Pendo: segment query |
| 5 | 10-30% das contas | Pendo: segment query |
| 3 | 5-10% das contas | Pendo: filtro por segmento |
| 1 | <5% das contas | Pendo: nicho ou edge case |

**Como calcular**:
1. Identificar feature/módulo/página do Pendo mais relacionada à oportunidade
2. Usar `activityQuery` para contar contas/visitors únicos nos últimos 30 dias
3. Comparar com total de contas ativas (`accountQuery` com `count: true`)
4. Normalizar para escala 1-10

**Pendo IDs**: Ver CLAUDE.md (seção "Pendo — IDs Importantes")

### Impact (I) — Impacto na experiência
**Fontes**: Pendo (frustration metrics) + Discovery (touchpoints) + NPS (correlação)

| Score | Critério | Evidência |
|-------|----------|-----------|
| 3 (Alto) | Resolve dor crítica, impede churn | Frustration alta + múltiplos touchpoints + detratores NPS mencionam |
| 2 (Médio) | Melhora significativa de experiência | Frustration moderada OU touchpoints consistentes |
| 1 (Baixo) | Nice-to-have, melhoria incremental | Poucos touchpoints, sem frustration |
| 0.5 (Mínimo) | Impacto marginal | 1 menção isolada, sem dados quantitativos |

**Como calcular**:
1. **Frustration metrics** (Pendo): verificar rage clicks, dead clicks, u-turns na feature/página relacionada
2. **Touchpoints**: contar quantos touchpoints em `reports/discovery/` mencionam a dor
3. **NPS**: verificar se detratores mencionam o tema (via `guideMetrics` do NPS guide `AIIkwUJTelmBTf-R7aiUjT5V9oQ`)
4. Combinar: frustration alta + touchpoints + NPS = 3; parcial = 2; pouco = 1; nada = 0.5

### Confidence (C) — Força da evidência
**Fontes**: combinação de todas as fontes

| Score | Critério | Evidência |
|-------|----------|-----------|
| 1.0 (Forte) | Quanti + quali + múltiplas fontes | Dados Pendo + 3+ touchpoints + 2+ fontes diferentes |
| 0.8 (Boa) | Quanti OU quali com boa cobertura | Dados Pendo sem discovery OU 3+ touchpoints sem Pendo |
| 0.5 (Palpite) | Evidência fraca ou única fonte | 1 touchpoint ou 1 fonte sem dados quantitativos |

**Como calcular**:
1. Contar fontes distintas que reportaram (das 7 fontes do processo)
2. Verificar se há dados quantitativos do Pendo
3. Verificar se há evidência qualitativa de discovery
4. Combinar: quanti + quali = 1.0; só um = 0.8; palpite = 0.5

### Effort (E) — Estimativa do PM
**Fonte**: input do PM com T-shirt sizes

| T-shirt | Sprints | Score |
|---------|---------|-------|
| XS | <0.5 sprint | 0.5 |
| S | 1 sprint | 1 |
| M | 2 sprints | 2 |
| L | 3 sprints | 3 |
| XL | 5+ sprints | 5 |

**Como calcular**:
1. Perguntar ao PM: "Qual o esforço estimado? (XS/S/M/L/XL)"
2. Se PM não souber, sugerir baseado no escopo descrito
3. Converter para score

### OKR Alignment (A) — Opcional, Fase 4
**Fonte**: OKRs ativos em `reports/strategy/okrs/` + agent `okr-alignment-scorer`

| Score | Nível | Critério |
|-------|-------|---------|
| 5 | Direto | Resolve diretamente um KR — implementar move o KR de forma mensurável |
| 4 | Forte | Contribui fortemente para um objetivo — impacto claro mas indireto no KR |
| 3 | Moderado | Relacionado a um objetivo — suporta o tema mas impacto no KR é incerto |
| 2 | Fraco | Tangencialmente relacionado — efeito indireto em algum objetivo |
| 1 | Nenhum | Sem relação clara com nenhum OKR ativo |

**Como calcular**:
1. Verificar se existem OKRs ativos em `reports/strategy/okrs/`
2. Se existem: delegar ao agent `okr-alignment-scorer` (haiku) para classificação automática
3. Se não existem: **omitir** — RICE puro, backward compatible
4. Score é determinado pelo agent com base na análise de alinhamento

**OKR Alignment Factor** (para Strategic Priority):

| Alignment | Fator |
|-----------|-------|
| 5 (Direto) | 1.5 |
| 4 (Forte) | 1.3 |
| 3 (Moderado) | 1.0 (neutro) |
| 2 (Fraco) | 0.8 |
| 1 (Nenhum) | 0.6 |

## Fluxo de Execução

### 1. Identificar oportunidade
- PM fornece ID da oportunidade (OPP-YYYY-NNN) ou descreve
- Ler arquivo em `reports/backlog/opportunities/`
- Verificar que tipo é `feature` ou `improvement` (RICE não se aplica a bugs ou tech-debt)

### 2. Calcular Reach
- Identificar feature/módulo/página no Pendo mais relacionada
- Usar `searchEntities` para encontrar IDs relevantes no Pendo
- Usar `activityQuery` para medir alcance nos últimos 30 dias
- Normalizar para escala 1-10

### 3. Calcular Impact
- Consultar frustration metrics no Pendo para feature/módulo
- Contar touchpoints de discovery que mencionam a dor
- Verificar correlação com NPS se possível
- Classificar 0.5 / 1 / 2 / 3

### 4. Calcular Confidence
- Contar fontes distintas
- Verificar presença de dados quanti e quali
- Classificar 0.5 / 0.8 / 1.0

### 5. Coletar Effort
- Perguntar ao PM o T-shirt size
- Converter para score

### 6. Calcular RICE
- RICE = (R × I × C) / E

### 7. Calcular OKR Alignment e Strategic Priority (Fase 4, opcional)
- Verificar se `reports/strategy/okrs/` contém OKRs com status `active`
- Se sim: invocar agent `okr-alignment-scorer` (haiku, max 10 turns) passando o ID da oportunidade
- Receber score de alignment (1-5) e justificativa
- Calcular **Strategic Priority** = RICE × OKR_Alignment_Factor
- Se não há OKRs ativos: registrar apenas RICE (backward compatible)

### 8. Registrar scores
- Atualizar arquivo da oportunidade com `rice_score`
- Se Fase 4: atualizar também `okr_alignment` e `strategic_priority` no frontmatter
- Atualizar `opportunity-index.json`

## Formato de Saída

```
# RICE Score — [OPP-YYYY-NNN] [Título]

## Componentes

### Reach: [X]/10
- Feature/módulo Pendo: [nome] (ID: [id])
- Contas ativas que usam: [N] de [total] ([%])
- Segmentos impactados: [SMB/Mid/Enterprise]

### Impact: [X] (Alto/Médio/Baixo/Mínimo)
- Frustration metrics: [rage clicks: N, dead clicks: N, u-turns: N]
- Touchpoints de discovery: [N] mencionam a dor
- Correlação NPS: [detratores mencionam / não mencionam]

### Confidence: [X] (Forte/Boa/Palpite)
- Fontes: [N] de 7 ([listar])
- Dados quantitativos: [sim/não]
- Evidência qualitativa: [sim/não — N touchpoints]

### Effort: [X] ([T-shirt size])
- Estimativa PM: [justificativa]

## RICE Score Final

**RICE = ([R] × [I] × [C]) / [E] = [resultado]**

## Strategic Priority (Fase 4 — se OKRs ativos)

### OKR Alignment: [X]/5 ([Direto/Forte/Moderado/Fraco/Nenhum])
- Objetivo alinhado: [título do objetivo]
- KR alinhado: [KR específico]
- Justificativa: [do okr-alignment-scorer]

### Strategic Priority
**Strategic Priority = RICE ([X]) × OKR Factor ([X]) = [resultado]**

> Se não há OKRs ativos, esta seção é omitida e o ranking usa RICE puro.

## Ranking Comparativo

| # | Oportunidade | RICE | OKR Align | Strat.Prio | R | I | C | E |
|---|-------------|------|----------|-----------|---|---|---|---|
| 1 | [esta] | [X] | [X] | [X] | [X] | [X] | [X] | [X] |
| 2 | [outra scored] | [X] | [X] | [X] | [X] | [X] | [X] | [X] |
| ... | | | | | | | | |

> Ranking ordenado por Strategic Priority (se disponível) ou RICE (se sem OKRs).

## Recomendação
- [Se Strategic Priority alto: "Alta prioridade estratégica — candidata forte para roadmap committed"]
- [Se RICE alto mas OKR baixo: "RICE alto mas pouco alinhado com OKRs — considerar se há gap estratégico"]
- [Se RICE baixo mas OKR alto: "Alinhado com OKRs mas baixo impacto/evidência — coletar mais dados"]
- [Se ambos baixos: "Baixa prioridade — manter no backlog ou rejeitar"]
```

## Recálculo

- RICE pode ser recalculado quando novos dados chegam (mais touchpoints, novos dados Pendo)
- Ao recalcular, comparar com score anterior e explicar o que mudou

## Atualização de Confidence pós-validação (Fase 5)

Quando um Teste de Aposta (bet test) via `/bet-test-manager` é completado, a Confidence do RICE deve ser recalculada com base nos resultados da validação:

### Regras de recálculo

| Resultado do bet test | Nova Confidence | Justificativa |
|----------------------|----------------|---------------|
| **Passed** — todas assumptions críticas validadas | 1.0 (Forte) | Evidência quanti + quali + validação direta |
| **Passed** — maioria validada, algumas incertas | 0.8 (Boa) | Boa evidência, risco residual baixo |
| **Failed** — assumptions críticas invalidadas | 0.5 ou menor (Palpite) | Evidência contrária, incerteza permanece |

### Fluxo de recálculo pós-validação

1. Ler resultado do bet test em `reports/strategy/validation/bet-*.md`
2. Determinar nova Confidence conforme tabela acima
3. Recalcular RICE com nova Confidence: `RICE = (R × I × C_novo) / E`
4. Se OKRs ativos: recalcular Strategic Priority = RICE_novo × OKR_Alignment_Factor
5. Atualizar arquivo da oportunidade com:
   - `rice_score` recalculado
   - `strategic_priority` recalculada (se aplicável)
   - `confidence_validated: true` no frontmatter
6. Atualizar `opportunity-index.json`
7. Informar PM do delta: "RICE anterior: [X] → RICE novo: [Y] (Confidence: [antes] → [depois])"

### Exemplo

**Bet test BET-2026-001 para IDEA-2026-005** (Filtros avançados no pipeline):
- Confidence antes: 0.5 (Palpite — 1 touchpoint, sem dados Pendo)
- Resultado: passed (protótipo + 4 entrevistas validaram valor)
- Confidence depois: 0.8 (Boa — evidência quali forte)
- RICE antes: (7 × 2 × 0.5) / 2 = 3.5
- RICE depois: (7 × 2 × 0.8) / 2 = **5.6** (+60%)
- Strategic Priority antes: 3.5 × 1.3 = 4.55
- Strategic Priority depois: 5.6 × 1.3 = **7.28** (+60%)

## Exemplo

**Input**: "Pontua a OPP-2026-005 — Filtros avançados no pipeline"

**Output**:
- Reach: 7/10 — 42% das contas ativas usam pipeline diariamente (Pendo)
- Impact: 2 (Médio) — 3 touchpoints mencionam frustração com filtros, rage clicks moderados na página de filtros
- Confidence: 1.0 (Forte) — dados Pendo + 3 touchpoints + pedidos de vendas e CS
- Effort: M (2 sprints) — estimativa PM
- **RICE = (7 × 2 × 1.0) / 2 = 7.0**
- OKR Alignment: 4 (Forte) — alinhado com Obj 1 "Aumentar produtividade dos vendedores", KR 1.2 "Reduzir tempo médio de qualificação"
- **Strategic Priority = 7.0 × 1.3 = 9.1**
- Ranking: #2 de 8 oportunidades por Strategic Priority

## Observações

- RICE é para Features e Melhorias. Bugs usam SLA por severidade. Tech debt usa reserva de 15-20%
- Se não houver dados do Pendo para a feature, usar Confidence 0.5 e explicar
- Effort é a estimativa mais subjetiva — sempre pedir input do PM
- RICE alto com Confidence baixa pode ser enganoso — sempre destacar a Confidence
- Rankings são relativos ao momento — atualizar quando novos scores forem calculados
