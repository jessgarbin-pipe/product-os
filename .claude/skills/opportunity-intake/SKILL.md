---
name: opportunity-intake
description: "Ponto único de entrada para demandas de todas as 7 fontes do Piperun. Classifica automaticamente (Bug/Tech Debt/Feature/Melhoria), roteia via dual-path (Fast Lane ou Discovery Lane), registra no Opportunity Backlog com ID único e linka evidências existentes. Use SEMPRE que o usuário mencionar: registrar demanda, nova demanda, recebi um pedido, sugestão de cliente, bug reportado, débito técnico, registrar oportunidade, intake, demanda de vendas, demanda do CS, recebi feedback, oportunidade identificada, registrar bug, nova feature request, pedido de melhoria, tech debt, ou qualquer variação."
---

# Intake Unificado de Demandas — Opportunity Intake

Skill para registrar demandas de qualquer fonte no Opportunity Backlog do Piperun, com classificação automática e roteamento dual-path (Fast Lane / Discovery Lane).

## 7 Fontes de Demanda Aceitas

| # | Fonte | Identificador | Como chega |
|---|-------|--------------|-----------|
| 1 | Sugestões de clientes | `customer-suggestion` | PM relata feedback direto de cliente |
| 2 | Sugestões internas (vendas) | `internal-sales` | Slack ou reunião |
| 3 | Sugestões internas (CS) | `internal-cs` | Slack ou reunião |
| 4 | Sugestões internas (implantação) | `internal-implantation` | Slack ou reunião |
| 5 | Insights dos PMs (discovery) | `pm-discovery` | Touchpoints de discovery (Fase 2) |
| 6 | Report de bugs | `bug-report` | Movidesk, Slack, direto |
| 7 | Código legado / débito técnico | `tech-debt` | Code review, observação técnica |
| 8 | Insights de monitoramento | `monitoring-insight` | Anomalias, alertas, métricas (Fase 1) |

## Roteamento Dual-Path

```
Demanda bruta → [demand-router agent] → tipo + severidade + certeza
                                              │
                              ┌───────────────┴───────────────┐
                              ▼                               ▼
                     FAST LANE                        DISCOVERY LANE
                  (certeza = clear)                (certeza = uncertain)
                              │                               │
                              ▼                               ▼
                  status: fast-lane                status: needs-discovery
                  Sugere criar Issue               Sugere próximos passos
                  imediatamente via                de discovery
                  delivery-backlog-sync
```

### Fast Lane (Direto para Delivery)
- Demanda clara, bem definida, bom tamanho para execução
- P0/P1 SEMPRE vão para Fast Lane (bypass do ciclo)
- Após registro, sugerir ao PM criar GitHub Issue via `/delivery-backlog-sync`

### Discovery Lane (Opportunity Backlog → Discovery → Delivery)
- Demanda incerta, precisa de pesquisa ou validação
- Registra com `status: needs-discovery`
- Sugere: discovery prep, touchpoint, dados do Pendo a investigar

### Override do PM
O PM pode sobrescrever a sugestão do router:
- Forçar Fast Lane: "isso é claro, vai direto"
- Forçar Discovery Lane: "quero investigar mais antes"

## Fluxo de Execução

### 1. Receber a demanda
- PM descreve a demanda em texto livre
- Perguntar fonte se não mencionada: "De onde veio essa demanda?"
- Perguntar módulo se não óbvio

### 2. Classificar via demand-router
- Delegar classificação ao agent `demand-router` (haiku, rápido)
- Receber: tipo + severidade + certeza + routing + justificativa

### 3. Verificar P0/P1 (escalação imediata)
- Se P0: **MENSAGEM DE ESCALAÇÃO IMEDIATA**
  ```
  🚨 ALERTA P0 — [título]
  SLA: Resposta em 30min | Correção em 4h
  AÇÃO IMEDIATA: Notificar Head de Produto + Tech Lead
  ```
- Se P1: **MENSAGEM DE ALERTA**
  ```
  ⚠️ ALERTA P1 — [título]
  SLA: Resposta em 2h | Correção em 24h
  AÇÃO: Notificar Tech Lead
  ```

### 4. Buscar evidências existentes
- Buscar touchpoints em `reports/discovery/touchpoint-*.md` com keywords da demanda
- Buscar oportunidades existentes em `reports/backlog/opportunity-index.json` (duplicatas)
- Se relevante, sugerir consulta ao Pendo (usage, frustration)

### 5. Gerar ID e registrar
- Ler `reports/backlog/opportunity-index.json` para obter `nextId`
- Gerar ID: `OPP-{ano}-{nextId padded com 3 dígitos}` (ex: OPP-2026-001)
- Gerar slug: kebab-case do título (max 50 chars)
- Arquivo: `reports/backlog/opportunities/OPP-YYYY-NNN-slug.md`

### 6. Criar arquivo da oportunidade

```yaml
---
id: OPP-YYYY-NNN
title: "Título descritivo da demanda"
type: feature  # bug | tech-debt | feature | improvement
status: new    # new → fast-lane | needs-discovery (definido pelo routing)
lane: fast     # fast | discovery
source: internal-sales  # uma das 7+ fontes
source_detail: "Canal #vendas-produto, Maria Silva, 2026-03-02"
severity: null  # P0-P3 (somente para bugs)
module: integracoes
reporter: "Nome do PM"
created: "2026-03-02T14:30:00"  # Use ISO 8601 with time for P0/P1 (SLA in minutes/hours)
updated: "2026-03-02T14:30:00"
rice_score: null
evidence_count: 0
linked_touchpoints: []
linked_issues: []
delivery_issue: null
tags: [tag1, tag2]
---

## Descrição

[Descrição completa da demanda no texto do PM]

## Classificação

- **Tipo**: [tipo] — [justificativa do demand-router]
- **Roteamento**: [Fast Lane | Discovery Lane] — [motivo]
- **Confiança**: [high/medium/low]

## Evidências Existentes

### Touchpoints linkados
- [se encontrados, listar com data e cliente]

### Dados quantitativos
- [se consultados no Pendo, resumir]

## Próximos Passos

### Se Fast Lane:
- [ ] Criar GitHub Issue via `/delivery-backlog-sync`
- [ ] [ação específica se bug: investigar reprodução]

### Se Discovery Lane:
- [ ] [ação de discovery sugerida: prep, touchpoint, análise Pendo]
- [ ] Calcular RICE score via `/rice-scorer` quando houver evidência
- [ ] Promover para Delivery quando validada via `/opportunity-backlog-manager`
```

### 7. Atualizar opportunity-index.json
- Incrementar `nextId`
- Adicionar entrada no array `opportunities`:
  ```json
  {
    "id": "OPP-YYYY-NNN",
    "title": "Título",
    "type": "feature",
    "status": "fast-lane",
    "lane": "fast",
    "source": "internal-sales",
    "severity": null,
    "module": "integracoes",
    "created": "2026-03-02",
    "rice_score": null,
    "file": "OPP-YYYY-NNN-slug.md"
  }
  ```

### 8. Apresentar resultado ao PM
- Resumo da classificação
- Se P0/P1: mensagem de escalação
- Se Fast Lane: sugerir criar Issue
- Se Discovery Lane: sugerir próximos passos de discovery
- Se duplicata potencial encontrada: sinalizar

## Exemplo — Bug P1 (Fast Lane)

**Input**: "O módulo de automações parou de disparar emails para clientes do plano Enterprise. CS reportou que 5 clientes grandes estão reclamando."

**Output**:
- Tipo: Bug | Severidade: P1 | Certeza: clear | Lane: Fast
- ⚠️ ALERTA P1 — Automações não disparam emails (Enterprise)
- ID: OPP-2026-015
- Próximo passo: Criar GitHub Issue imediatamente via `/delivery-backlog-sync`

## Exemplo — Feature (Discovery Lane)

**Input**: "O time de vendas pediu integração com WhatsApp pra enviar mensagens direto do pipeline."

**Output**:
- Tipo: Feature | Severidade: — | Certeza: uncertain | Lane: Discovery
- ID: OPP-2026-016
- Motivo Discovery: escopo vago, múltiplas abordagens possíveis (Business API, template messages, chatbot)
- Próximo passo: `/discovery-prep` para WhatsApp, touchpoint com cliente que mais usa comunicação

## Observações

- Se o PM mencionar "isso é urgente" sem evidência de impacto sistêmico, NÃO classificar automaticamente como P0/P1 — perguntar sobre impacto real
- Sempre buscar duplicatas antes de registrar — a mesma demanda pode já existir com outro nome
- Se a demanda veio de discovery (touchpoint), linkar o touchpoint automaticamente
- Se o PM quer registrar múltiplas demandas de uma vez, processar uma a uma e confirmar cada classificação
- Manter linguagem original do solicitante nas citações e na descrição
