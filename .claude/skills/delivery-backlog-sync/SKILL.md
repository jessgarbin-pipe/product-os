---
name: delivery-backlog-sync
description: "Sincroniza o Delivery Backlog do Piperun com GitHub Issues. Cria issues a partir de oportunidades promovidas (Fast Lane e Discovery Lane), aplica labels padronizadas, rastreia velocity e métricas de lane. Use SEMPRE que o usuário mencionar: criar issue, delivery backlog, sincronizar delivery, ver issues, GitHub Issues, backlog de delivery, o que está para executar, velocity, criar GitHub Issue, promover issue, ou qualquer variação."
---

# Sincronização com GitHub Issues — Delivery Backlog

Skill para criar e gerenciar GitHub Issues a partir de oportunidades promovidas do Opportunity Backlog (tanto Fast Lane quanto Discovery Lane).

## Labels Padronizadas

### Tipo
- `type:bug`
- `type:feature`
- `type:improvement`
- `type:tech-debt`

### Severidade (bugs)
- `severity:P0`
- `severity:P1`
- `severity:P2`
- `severity:P3`

### RICE (features/improvements)
- `rice:high` (RICE ≥ 6)
- `rice:medium` (RICE 3-5.9)
- `rice:low` (RICE < 3)

### Módulo
- `mod:pipeline`
- `mod:contatos`
- `mod:atividades`
- `mod:automacoes`
- `mod:relatorios`
- `mod:integracoes`
- `mod:admin`
- `mod:outro`

### Lane de origem
- `lane:fast`
- `lane:discovery`

### Fonte
- `source:product-os`

### Concepcao (Fase 6)
- `conception:prd` — originado de PRD completo
- `conception:onepager` — originado de one-pager
- `conception:issue` — originado de issue estruturada

### Launch (Fase 8)
- `launch:LAUNCH-YYYY-NNN` — vinculado a um launch doc específico

## Fluxo de Execução

### 1. Criar GitHub Issue a partir de oportunidade
**Trigger**: "criar issue para OPP-YYYY-NNN", "promover para delivery"

**Processo**:
1. Ler oportunidade em `reports/backlog/opportunities/OPP-*.md`
2. Verificar que status permite promoção:
   - Fast Lane: `fast-lane` → pode criar
   - Discovery Lane: `validated` → pode criar (passou pelo opportunity-validator)
3. Montar labels com base no tipo, severidade, RICE, módulo e lane
4. Montar body da Issue:

```markdown
## Contexto

[Descrição da oportunidade]

## Origem

- **Opportunity ID**: OPP-YYYY-NNN
- **Lane**: [Fast/Discovery]
- **Fonte**: [fonte original]
- **Registrado em**: [data]

## Evidências

[Resumo das evidências — touchpoints, dados Pendo, feedbacks]

## RICE Score

[Se Discovery Lane com RICE calculado]
- Reach: X | Impact: X | Confidence: X | Effort: X
- **RICE = X**

## Critérios de Aceite

- [ ] [critério 1 — extraído da descrição]
- [ ] [critério 2]

---
_Criado via Product OS — Delivery Backlog Sync_
```

5. Criar issue via `gh issue create`:
   ```bash
   gh issue create --title "[título]" --body "[body]" --label "type:X,severity:X,mod:X,lane:X,source:product-os"
   ```

6. Registrar issue number de volta na oportunidade:
   - Atualizar campo `delivery_issue` no frontmatter
   - Atualizar `status` para `promoted`
   - Atualizar `opportunity-index.json`

7. Confirmar ao PM com link da Issue

### 2. Listar Delivery Backlog
**Trigger**: "ver delivery backlog", "issues abertas", "o que está para executar"

```bash
gh issue list --label "source:product-os" --state open
```

**Formato**:
```
# Delivery Backlog — Piperun
**Data**: [data] | **Issues abertas**: [N]

## Por Tipo
| Tipo | Abertas | Fechadas (30d) |
|------|---------|---------------|
| Bug | N | N |
| Feature | N | N |
| Improvement | N | N |
| Tech Debt | N | N |

## Por Severidade (Bugs)
| Severidade | Abertas | Status SLA |
|-----------|---------|-----------|
| P0 | N | [OK/Violação] |
| P1 | N | [OK/Violação] |
| P2 | N | [OK/Atrasada] |
| P3 | N | [OK/Atrasada] |

SLA targets: ver CLAUDE.md (seção "Padrões de Severidade de Bugs").

## Por Lane de Origem
| Lane | Abertas | % | Tempo médio aberta |
|------|---------|---|-------------------|
| Fast | N | X% | Xd |
| Discovery | N | X% | Xd |

## Issues Abertas
| # | Título | Tipo | Sev. | Módulo | Lane | Idade |
|---|--------|------|------|--------|------|-------|
| #N | [título] | bug | P1 | [mod] | fast | Xd |
```

### 3. Velocity
**Trigger**: "velocity", "abertas vs fechadas"

```bash
# Issues abertas nos últimos 30 dias
gh issue list --label "source:product-os" --state all --json number,title,createdAt,closedAt
```

**Formato**:
```
## Velocity — Últimos 30 dias
- Abertas: [N]
- Fechadas: [N]
- Net: [+/-N]
- Tempo médio de resolução: [Xd]
- Backlog trend: [crescendo/estável/diminuindo]
```

### 4. Capacidade Tech Debt
**Trigger**: "capacidade tech debt no delivery"

```bash
gh issue list --label "type:tech-debt,source:product-os" --state open
gh issue list --label "source:product-os" --state open
```

- Calcular % de tech debt no total
- Meta: 15-20%
- Alertar se fora da faixa

### 5. Tracking P0/P1
**Trigger**: "P0 P1 abertos", "bugs críticos"

```bash
gh issue list --label "severity:P0" --state open
gh issue list --label "severity:P1" --state open
```

- Listar com tempo aberto
- Comparar com SLA (P0: 4h correção, P1: 24h)
- Alertar violações

### 6. Métricas de Lane
**Trigger**: "métricas de lane", "fast vs discovery"

- Calcular:
  - % Fast Lane vs Discovery Lane (issues criadas)
  - Tempo médio por lane (da intake ao close)
  - Taxa de sucesso por lane (fechadas/abertas)

## Observações

- Sempre confirmar com o PM antes de criar a GitHub Issue
- Se o repositório não tem as labels, criar via `gh label create`
- Nunca fechar GitHub Issues automaticamente — isso é responsabilidade do dev/PM
- Se a oportunidade já tem `delivery_issue` preenchido, avisar que já foi promovida
- Body da Issue deve ser auto-suficiente (dev não precisa ler o arquivo de oportunidade)
- Labels `source:product-os` permite filtrar Issues criadas pelo sistema vs criadas manualmente
- **Template enriquecido (Fase 6)**: Se a oportunidade tem `conception_ref`, usar template enriquecido com JTBD, metricas, rollout e link para PRD/one-pager. Adicionar label `conception:prd`, `conception:onepager` ou `conception:issue` conforme o nivel do documento de concepcao
- **Integracao com delivery-tracker (Fase 7)**: Issues criadas pelo delivery-backlog-sync alimentam o sprint dashboard do `/delivery-tracker`. Ao fazer ship via `/delivery-tracker`, a label `launch:LAUNCH-YYYY-NNN` pode ser adicionada para vincular ao launch doc. Use `/delivery-tracker` para sprint planning, velocity e ship items
