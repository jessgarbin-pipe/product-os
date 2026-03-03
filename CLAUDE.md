# Product OS — Piperun CRM

Sistema de inteligência de produto para o CRM Piperun (Fases 1-8: Monitoramento, Discovery, Triagem, Estratégia, Validação, Concepção, Delivery, GTM).

## Contexto

O Piperun CRM está reestruturando o produto para ser escalável e acelerar time to market. Este repositório contém skills (`.claude/skills/`), agents (`.claude/agents/`) e hooks que compõem o Product OS — um sistema que automatiza análises de monitoramento e gera insights acionáveis para o time de produto.

## Ferramentas e Fontes de Dados

| Ferramenta | Tipo | Acesso | Dados |
|-----------|------|--------|-------|
| **Pendo** | MCP | Direto (MCP tools) | Uso, NPS, CSAT, features, guides, frustration metrics |
| **Metabase** | SQL | Via Bash (MySQL) | Dados financeiros, contas, MRR, churn |
| **Movidesk** | CSV | Upload manual | Bugs, SLAs, tickets de suporte, feedbacks CS |
| **Slack** | MCP/Manual | Via canais | Demandas internas, pedidos de vendas/CS/suporte |
| **Web** | WebSearch | Direto | Concorrentes, tendências, benchmarks |

### Pendo — IDs Importantes

- **Subscription ID**: `4732442263093248`
- **App "PipeRun CRM Web"**: `-323232`
- **NPS Guide**: `AIIkwUJTelmBTf-R7aiUjT5V9oQ` (Poll: `to4m53fjf4n`)

### Padrões de Severidade de Bugs

| Severidade | Critério | Tempo de Resposta | Tempo de Resolução |
|-----------|----------|------------------|-------------------|
| P0 (Crítico) | Clientes perdendo dinheiro. Sistema inoperável | 30min | 4h |
| P1 (Alto) | Piperun perdendo dinheiro. Função crítica degradada | 2h | 24h |
| P2 (Médio) | Funcionalidade degradada com workaround | 24h | Sprint corrente |
| P3 (Baixo) | Cosmético ou edge case | Backlog | Próxima sprint |

- P0/P1 **bypassa ciclo normal** — execução imediata
- P2/P3 entram na reserva de **15-20% da capacidade** de sprint
- P0: PM notifica Head + Tech Lead em 30min

## Concorrentes Monitorados

**Consolidados**: Pipedrive, RD Station CRM, HubSpot CRM, Ploomes
**Emergentes**: Nectar CRM, Moskit CRM, Agendor, Fleeg

## Visão Executiva (4 dashboards)

1. `/monitoring-snapshot` (Fase 1) — métricas de uso, NPS, bugs
2. `/discovery-cadence-report` (Fase 2) — cadência de discovery, touchpoints
3. `/triage-dashboard` (Fase 3) — pipeline de triagem, SLA, delivery
4. `/strategy-dashboard` (Fases 4-8) — OKRs, OST, roadmap, validação, concepção, delivery, GTM

## Convenções

- **Nomes de arquivos**: inglês (kebab-case)
- **Conteúdo/descrições**: português do Brasil
- **Termos técnicos**: inglês (NPS, CSAT, churn, feature, pipeline)
- **Modelo de dados**: Pendo para behavioral, Metabase para financial, Movidesk para support
