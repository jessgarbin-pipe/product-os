---
name: okr-manager
description: "Gerencia OKRs trimestrais do Piperun: criar, acompanhar progresso, avaliar, linkar oportunidades. Lifecycle: draft > active > review > closed. KR progress tracking com dados do Pendo e Metabase. Use SEMPRE que o usuário mencionar: OKR, objetivos do quarter, key results, criar OKR, ver OKRs, atualizar KR, progresso do OKR, definir objetivos, check-in de OKR, review de OKR, metas do trimestre, ou qualquer variação."
---

# Gestão de OKRs Trimestrais — Piperun

Skill para criar, acompanhar e avaliar OKRs de produto alinhados com os objetivos da empresa. Cada squad sabe quais KRs ataca.

## Fontes de Dados

| Fonte | Localização | O que contém |
|-------|-------------|-------------|
| OKRs | `reports/strategy/okrs/okrs-YYYY-QN.md` | OKRs do quarter |
| Pendo | MCP tools | DAU, WAU, MAU, retention, NPS, features (para KR progress) |
| Metabase | Via Bash (MySQL) | MRR, churn, contas (para KR progress financeiro) |
| Opportunity Backlog | `reports/backlog/opportunity-index.json` | Oportunidades linkadas a objetivos |
| OST | `reports/strategy/ost/ost-index.json` | Opportunity Solution Tree |

## Lifecycle de OKRs

```
draft → active → review → closed
```

- `draft`: em construção, quarter ainda não iniciou ou OKRs em refinamento
- `active`: quarter em andamento, KRs sendo perseguidos
- `review`: fim do quarter, avaliando resultados
- `closed`: quarter encerrado, scoring final aplicado

## Storage

**Arquivo**: `reports/strategy/okrs/okrs-YYYY-QN.md`

**Frontmatter obrigatório** (validado pelo hook `validate-okr-entry.sh`):
```yaml
---
quarter: "2026-Q2"
status: draft | active | review | closed
company_okrs_ref: "Referência aos OKRs da empresa (se houver)"
created: "2026-03-15"
updated: "2026-03-15"
---
```

## Formato do Arquivo de OKRs

```markdown
---
quarter: "2026-Q2"
status: active
company_okrs_ref: "Crescimento sustentável + Excelência de produto"
created: "2026-03-15"
updated: "2026-04-01"
---

# OKRs de Produto — 2026-Q2

## Objetivo 1: [Título do objetivo]
**Owner**: [Nome do PM/Squad]
**Alinhamento empresa**: [Qual OKR da empresa este objetivo suporta]

### KR 1.1: [Descrição mensurável]
- **Baseline**: [valor atual]
- **Target**: [valor alvo]
- **Atual**: [valor mais recente]
- **Progresso**: [X%]
- **Status**: on-track | at-risk | off-track
- **Fonte**: [Pendo: DAU / Metabase: MRR / etc.]
- **Última medição**: [data]

### KR 1.2: [Descrição mensurável]
- **Baseline**: [valor atual]
- **Target**: [valor alvo]
- **Atual**: [valor mais recente]
- **Progresso**: [X%]
- **Status**: on-track | at-risk | off-track
- **Fonte**: [fonte de dados]
- **Última medição**: [data]

### Oportunidades linkadas
| ID | Título | RICE | Status |
|----|--------|------|--------|
| OPP-2026-001 | [título] | 7.0 | researching |

---

## Objetivo 2: [Título do objetivo]
...

---

## Scoring Final (preenchido em status: review/closed)

| Objetivo | Score (0-1) | Avaliação |
|----------|-------------|-----------|
| Obj 1 | [média dos KRs] | [comentário] |
| Obj 2 | [média dos KRs] | [comentário] |
| **Média geral** | **[X]** | |
```

## Operações

### 1. Criar OKRs do Quarter
**Trigger**: "criar OKR", "definir objetivos do Q2", "novo quarter"

**Fluxo**:
1. Perguntar ao PM:
   - Qual quarter? (ex: 2026-Q2)
   - Quantos objetivos? (recomendado: 2-4)
   - Para cada objetivo: título, owner, alinhamento com empresa
   - Para cada KR: descrição mensurável, baseline, target, fonte de dados
2. Criar arquivo `reports/strategy/okrs/okrs-YYYY-QN.md` com status `draft`
3. Informar PM que pode ativar quando pronto

**Boas práticas para OKRs**:
- Objetivos: aspiracionais, qualitativos, inspiradores
- KRs: mensuráveis, com baseline e target numéricos
- 2-4 objetivos por quarter, 2-4 KRs por objetivo
- KRs devem ter fonte de dados clara (Pendo, Metabase, etc.)

### 2. Check-in de OKRs (mensal)
**Trigger**: "check-in de OKR", "progresso do OKR", "como estamos nos OKRs"

**Fluxo**:
1. Ler OKRs ativos em `reports/strategy/okrs/`
2. Para cada KR com fonte Pendo:
   - Usar `activityQuery`, `accountQuery`, `guideMetrics` para obter valor atual
   - Calcular progresso: `(atual - baseline) / (target - baseline) * 100`
3. Para cada KR com fonte Metabase:
   - Informar PM que dados financeiros precisam ser fornecidos ou consultados via Bash
4. Atualizar campos: `atual`, `progresso`, `status`, `última medição`
5. Classificar status:
   - **on-track**: progresso >= (dias_decorridos / dias_totais * 100) - 10pp
   - **at-risk**: progresso entre 50-80% do esperado
   - **off-track**: progresso < 50% do esperado
6. Gerar resumo de check-in

**Formato do check-in**:
```
# Check-in OKR — [Quarter] — [Data]

## Resumo
- Objetivos: [N]
- KRs on-track: [N] | at-risk: [N] | off-track: [N]
- Progresso médio: [X%]

## Detalhamento

### Obj 1: [Título]
| KR | Target | Atual | Progresso | Status |
|----|--------|-------|-----------|--------|
| KR 1.1 | [target] | [atual] | [X%] | on-track |
| KR 1.2 | [target] | [atual] | [X%] | at-risk |

**KRs at-risk**: [KR 1.2] — [sugestão de ação]
**KRs off-track**: [nenhum]
```

### 3. Review de Fim de Quarter
**Trigger**: "review de OKR", "fechar quarter", "scoring final"

**Fluxo**:
1. Ler OKRs do quarter
2. Fazer check-in final de todos os KRs
3. Calcular score por KR: `min(atual / target, 1.0)` (cap em 1.0)
4. Calcular score por objetivo: média dos KRs
5. Calcular score geral: média dos objetivos
6. Atualizar status para `review`
7. Pedir comentários ao PM para cada objetivo
8. Quando PM confirmar, atualizar status para `closed`

**Referência de scoring**:
- 0.7-1.0: Excelente — KR bem calibrado e alcançado
- 0.4-0.6: Bom — progresso significativo, talvez meta ambiciosa demais
- 0.0-0.3: Insuficiente — requer análise de causa raiz

### 4. Listar OKRs
**Trigger**: "ver OKRs", "quais são os OKRs", "listar objetivos"

- Listar todos os arquivos em `reports/strategy/okrs/`
- Mostrar: quarter, status, número de objetivos, progresso médio
- Se há OKRs ativos, mostrar resumo rápido dos KRs

### 5. Linkar Oportunidade a Objetivo
**Trigger**: "linkar OPP-YYYY-NNN ao OKR", "conectar oportunidade ao objetivo"

- Ler oportunidade do backlog
- Ler OKRs ativos
- Adicionar oportunidade na tabela "Oportunidades linkadas" do objetivo
- Atualizar `opportunity-index.json` com campo `linked_okrs` (opcional, Fase 4)

## Integração com Outras Skills

| Skill/Agent | Direção | Dados |
|-------------|---------|-------|
| `usage-monitor` | → OKR | Métricas DAU/WAU/MAU para KRs de uso |
| `nps-analysis` | → OKR | NPS score para KRs de satisfação |
| `retention-cohort` | → OKR | Retenção D7/D30 para KRs de retenção |
| `churn-analysis` | → OKR | Churn rate para KRs de retenção financeira |
| `rice-scorer` | ← OKR | OKR alignment para RICE estendido (Fase 4) |
| `ost-builder` | ← OKR | Objetivos são raízes do OST |
| `strategy-dashboard` | ← OKR | Seção 1 — OKR Progress |
| `opportunity-backlog-manager` | ↔ OKR | Strategic View agrupa por OKR |

## Observações

- OKRs são definidos pelo PM com input da liderança — o sistema facilita, não decide
- Check-ins devem ser mensais no mínimo (hook `strategy-review-reminder.sh` cobra)
- KRs sem fonte de dados automatizada requerem input manual do PM
- Score 0.7 é considerado sucesso — metas devem ser ambiciosas (stretch goals)
- OKRs closed não são editados — servem como histórico
