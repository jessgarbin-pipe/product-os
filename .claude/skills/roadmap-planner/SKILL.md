---
name: roadmap-planner
description: "Gerencia o roadmap de produto do Piperun com 3 horizontes: Committed (Q atual), Planned (Q+1), Exploratory (Q+2+). Tracking de status, changelog, snapshots trimestrais e capacity check. Use SEMPRE que o usuário mencionar: roadmap, planejamento de quarter, o que vamos fazer Q1, Q2 planejado, itens committed, ver roadmap, atualizar roadmap, roadmap atual, committed vs planned, horizonte, ou qualquer variação."
---

# Planejamento de Roadmap — Piperun

Skill para gerenciar o roadmap de produto com 3 horizontes temporais. Flexível, atualizado com novos dados, conectado a OKRs e RICE.

## Conceito

O roadmap tem 3 horizontes:

| Horizonte | Período | Certeza | O que contém |
|-----------|---------|---------|-------------|
| **Committed** | Q atual | Alta | Itens validados, em execução ou prontos para iniciar |
| **Planned** | Q+1 | Média | Priorizados, podem mudar com novos dados |
| **Exploratory** | Q+2/Q+3 | Baixa | Direção estratégica, sem compromisso |

Itens fluem entre horizontes conforme ganham evidência e prioridade.

## Fontes de Dados

| Fonte | Localização | O que alimenta |
|-------|-------------|---------------|
| Opportunity Backlog | `reports/backlog/opportunity-index.json` | Oportunidades promovidas |
| Delivery Backlog | GitHub Issues (via `gh`) | Issues em execução |
| OKRs | `reports/strategy/okrs/okrs-YYYY-QN.md` | Alinhamento estratégico |
| OST | `reports/strategy/ost/ost-index.json` | Soluções validadas |
| Ideação | `reports/strategy/ideation/ideation-index.json` | Ideias aceitas |
| RICE | Oportunidades scored | Strategic Priority |

## Storage

### Roadmap atual: `reports/strategy/roadmap/roadmap-current.json`

```json
{
  "version": "1.0",
  "lastUpdated": "2026-03-15",
  "currentQuarter": "2026-Q2",
  "horizons": {
    "committed": {
      "quarter": "2026-Q2",
      "items": [
        {
          "id": "RM-001",
          "title": "Título do item",
          "type": "feature | improvement | tech-debt | bug-fix",
          "module": "pipeline",
          "opportunityRef": "OPP-2026-005",
          "ideaRef": "IDEA-2026-001",
          "conceptionRef": "PRD-2026-001",
          "launchRef": null,
          "deliveryIssue": "#123",
          "okrRef": "Obj 1 — KR 1.1",
          "strategicPriority": 10.5,
          "rice_score": 7.0,
          "okr_alignment": 4,
          "status": "not-started | in-progress | done | at-risk",
          "shippedDate": null,
          "reviewStatus": "none",
          "targetDate": "2026-06-15",
          "owner": "Squad Alpha",
          "addedDate": "2026-04-01",
          "notes": ""
        }
      ]
    },
    "planned": {
      "quarter": "2026-Q3",
      "items": []
    },
    "exploratory": {
      "quarters": "2026-Q4+",
      "items": []
    }
  },
  "changelog": [
    {
      "date": "2026-04-01",
      "action": "added",
      "itemId": "RM-001",
      "horizon": "committed",
      "reason": "Promovido do backlog — RICE 7.0, alinhado com OKR Obj 1"
    }
  ]
}
```

### Snapshot trimestral: `reports/strategy/roadmap/roadmap-YYYY-QN.md`

```markdown
---
quarter: "2026-Q2"
snapshot_date: "2026-06-30"
created: "2026-06-30"
---

# Roadmap Snapshot — 2026-Q2

## Committed (2026-Q2)
| ID | Título | Tipo | Status | OKR | Strat.Prio |
|----|--------|------|--------|-----|-----------|
| RM-001 | [título] | feature | done | Obj 1 | 10.5 |
| RM-002 | [título] | tech-debt | in-progress | - | - |

## Resultados
- Total committed: [N]
- Done: [N] ([X%])
- In-progress: [N] (carryover para Q3)
- At-risk: [N]
- Capacity utilization: [X%]
- Tech debt %: [X%] (meta: 15-20%)

## Planned (era Q3, agora committed)
[Itens que estavam em planned e agora viram committed no novo quarter]

## Changelog do Quarter
[Lista de movimentações entre horizontes]
```

## Status de Itens

| Status | Significado | Disponível em |
|--------|------------|--------------|
| `not-started` | Aprovado mas não iniciado | committed, planned |
| `in-progress` | Em desenvolvimento | committed |
| `done` | Concluído e lançado | committed |
| `at-risk` | Atrasado ou com bloqueios | committed |
| `candidate` | Candidato, sem compromisso | planned, exploratory |

## Operações

### 1. Ver Roadmap
**Trigger**: "ver roadmap", "roadmap atual", "o que temos para Q2"

**Formato**:
```
# Roadmap — Piperun
**Última atualização**: [data] | **Quarter atual**: [YYYY-QN]

## Committed — [Quarter] ([N] itens)
| ID | Título | Tipo | Módulo | Status | OKR | Strat.Prio | Owner |
|----|--------|------|--------|--------|-----|-----------|-------|
| RM-001 | [título] | feature | pipeline | in-progress | Obj 1 | 10.5 | Squad A |

**Progresso**: [N] done / [N] in-progress / [N] not-started / [N] at-risk

## Planned — [Q+1] ([N] itens)
| ID | Título | Tipo | Módulo | OKR | Strat.Prio | Candidato desde |
|----|--------|------|--------|-----|-----------|----------------|
| RM-005 | [título] | improvement | relatórios | Obj 2 | 8.0 | 2026-03-15 |

## Exploratory — [Q+2+] ([N] itens)
| ID | Título | Tipo | Direção estratégica |
|----|--------|------|-------------------|
| RM-010 | [título] | feature | IA / Automação |

## Capacity
- Tech debt: [N] itens ([X%] do committed) — Meta: 15-20%
- Bug fixes: [N] itens
- Features: [N] itens
- Improvements: [N] itens
```

### 2. Adicionar Item ao Roadmap
**Trigger**: "adicionar ao roadmap", "incluir no committed/planned/exploratory"

**Fluxo**:
1. PM indica:
   - Título e descrição
   - Horizonte: committed / planned / exploratory
   - Tipo: feature / improvement / tech-debt / bug-fix
   - Módulo
2. Verificar se há oportunidade no backlog (OPP-YYYY-NNN)
3. Verificar se há ideia associada (IDEA-YYYY-NNN)
4. **Validation gate (Fase 5)** — Se horizonte é `committed`:
   - Verificar Confidence da oportunidade/ideia
   - Se Confidence < 60% e sem bet test `passed` em `reports/strategy/validation/`:
     - Alertar PM: "Esta ideia tem Confidence [X]% e não passou por Teste de Aposta. Deseja prosseguir mesmo assim?"
     - PM pode overridar (gate flexível) — registrar justificativa no changelog
   - Se Confidence >= 60% (original ou pós-validação): OK, pode avançar
   - Se tipo é `tech-debt` ou `bug-fix`: gate não se aplica (bypass)
5. Verificar OKR alignment (se OKRs existem)
6. Gerar ID: `RM-NNN` (sequencial)
7. Adicionar ao roadmap-current.json (incluir campo opcional `validated: true/false/n-a`)
8. Registrar no changelog
9. Se committed, sugerir criação de GitHub Issue via `delivery-backlog-sync`

### 3. Mover Item Entre Horizontes
**Trigger**: "mover RM-001 para planned", "promover RM-005 para committed"

**Fluxo**:
1. Ler item atual
2. PM indica horizonte destino e motivo
3. Validar: item precisa de RICE/OKR alignment para ir a committed
4. Atualizar horizonte no JSON
5. Registrar no changelog com motivo
6. Se movendo para committed: verificar capacity

### 4. Atualizar Status de Item
**Trigger**: "atualizar RM-001 para in-progress", "marcar RM-002 como done"

- Atualizar status no JSON
- Registrar no changelog
- Se `done`: verificar se há resultado para medir no OST
- Se `at-risk`: perguntar motivo e registrar

### 5. Quarterly Snapshot
**Trigger**: "snapshot do quarter", "fechar roadmap do Q2"

**Fluxo**:
1. Ler roadmap-current.json
2. Gerar arquivo `reports/strategy/roadmap/roadmap-YYYY-QN.md` com estado atual
3. Calcular métricas:
   - Done rate: itens done / total committed
   - Carryover: itens not-started ou in-progress (vão para próximo quarter)
   - Capacity utilization
   - Tech debt %
4. Mover planned → committed para novo quarter
5. Mover exploratory → planned se apropriado
6. Atualizar currentQuarter em roadmap-current.json

### 6. Capacity Check
**Trigger**: "capacity check", "capacidade do quarter", "% tech debt no roadmap"

**Formato**:
```
# Capacity Check — [Quarter]

## Distribuição por Tipo
| Tipo | Committed | Planned | Meta |
|------|----------|---------|------|
| Feature | [N] ([X%]) | [N] | - |
| Improvement | [N] ([X%]) | [N] | - |
| Tech Debt | [N] ([X%]) | [N] | 15-20% |
| Bug Fix | [N] ([X%]) | [N] | Conforme SLA |

## Alerta Tech Debt
- Atual: [X%] — [Dentro da meta / Abaixo da meta / Acima da meta]
- Sugestão: [ação se fora da meta]

## Cobertura OKR
| Objetivo | Itens committed | Status |
|----------|----------------|--------|
| Obj 1 | [N] | Coberto |
| Obj 2 | [0] | SEM COBERTURA — risco para KRs |
```

### 7. Ship Item
**Trigger**: "ship RM-001", "marcar RM-001 como done e shipped"

**Fluxo**:
1. PM indica item do roadmap (RM-NNN)
2. Atualizar no roadmap-current.json:
   - `status` → `done`
   - `shippedDate` → hoje (YYYY-MM-DD)
3. Registrar no changelog
4. Delegar cascata para `/delivery-tracker` ship item (que atualiza oportunidade, ideia, OST)
5. Sugerir criar launch doc via `/gtm-feedback-loop` se nao existe `launchRef`

**Campos novos do item** (Fase 7+8):

| Campo | Tipo | Descricao |
|-------|------|-----------|
| `launchRef` | string ou null | ID do launch doc (LAUNCH-YYYY-NNN), vinculado via `/gtm-feedback-loop` |
| `shippedDate` | string ou null | Data de ship (YYYY-MM-DD), preenchido ao marcar done |
| `reviewStatus` | string | Status de review: `none` \| `d30-pending` \| `d30-done` \| `d90-pending` \| `d90-done` \| `closed` |

## Integração com Outras Skills

| Skill/Agent | Direção | Dados |
|-------------|---------|-------|
| `delivery-backlog-sync` | ↔ roadmap | Committed items referenciam GitHub Issues |
| `delivery-tracker` | ↔ roadmap | Sprint suggestion le items committed; ship item atualiza status e shippedDate |
| `gtm-feedback-loop` | ↔ roadmap | Launch doc vinculado via launchRef; D+30/D+90 atualiza reviewStatus |
| `okr-manager` | → roadmap | OKR alignment para itens |
| `rice-scorer` | → roadmap | Strategic Priority para ranking |
| `ost-builder` | → roadmap | Soluções validadas alimentam roadmap |
| `ideation-log` | → roadmap | Ideias aceitas são candidatas |
| `bet-test-manager` | → roadmap | Validation gate: Confidence >= 60% para committed (Fase 5) |
| `conception-manager` | ↔ roadmap | Campo `conceptionRef` vincula item do roadmap ao PRD/one-pager (Fase 6) |
| `opportunity-backlog-manager` | → roadmap | Oportunidades promovidas |
| `roadmap-optimizer` | → roadmap | Sugestão de alocação ótima |
| `strategy-dashboard` | ← roadmap | Seção 3 — Roadmap Status |

## Observações

- Roadmap é flexível — atualizado com novos dados, não gravado em pedra
- Committed não é "prometido ao cliente" — é "alta confiança de execução este quarter"
- Planned pode mudar 100% se novos dados justificarem
- Exploratory é direção, não compromisso
- Changelog é fundamental — registrar SEMPRE o motivo de movimentações
- Capacity check deve respeitar: tech debt 15-20%, P0/P1 dedicados, KRs at-risk prioritários
- **Concepcao check (Fase 6)**: Ao adicionar item committed do tipo feature/improvement, verificar se tem doc de concepcao (`conceptionRef`). Se nao tem e effort >= M, sugerir criar PRD/one-pager via `/conception-manager`
- **Ship e launch (Fases 7+8)**: Ao marcar done, preencher `shippedDate`. Se nao tem `launchRef`, sugerir criar launch doc via `/gtm-feedback-loop`. `reviewStatus` e atualizado automaticamente pelo feedback loop
