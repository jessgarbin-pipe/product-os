---
name: discovery-prep
description: "Prepara briefing pré-entrevista de discovery cruzando dados do Pendo, Movidesk e histórico de touchpoints. Gera perfil de uso, pontos de atenção e perguntas sugeridas para o PM. Use SEMPRE que o usuário mencionar: preparar entrevista, vou falar com cliente X, briefing pré-call, discovery prep, o que sei sobre conta X, preparar discovery, prep de entrevista, dados do cliente antes da call, ou qualquer variação. Também acione quando o PM informar que tem uma entrevista agendada."
---

# Preparação de Entrevista de Discovery

Skill para montar briefing pré-entrevista cruzando dados de múltiplas fontes, dando ao PM contexto rico antes de conversar com o cliente. Segue princípios de Teresa Torres: perguntas sobre comportamento passado, não opinião futura.

## Fontes de Dados

### Pendo (via MCP tools)
- **Atividade da conta**: `activityQuery` com `accountId`
- **Frustration metrics**: `activityQuery` com `frustrationMetrics: true`
- **Session replays**: `sessionReplayList` com filtro de conta
- **Features usadas**: `activityQuery` com `entityType: "feature"`, `accountId`
- **NPS/CSAT**: respostas via `searchEntities` com `itemType: ["Guide"]`
- **Metadata da conta**: `accountQuery` com `select` dos campos relevantes

### Movidesk (CSV se disponível)
- Tickets abertos e recentes da conta
- Histórico de reclamações e categorias
- SLA de atendimento

### Touchpoints anteriores
- Buscar em `reports/discovery/` por touchpoints anteriores com este cliente
- Verificar dores já identificadas e oportunidades mapeadas

### IDs Pendo
Ver CLAUDE.md (seção "Pendo — IDs Importantes")

## Fluxo de Execução

1. **Identificar a conta**
   - Receber nome da conta ou ID do PM
   - Buscar no Pendo via `searchEntities` com `itemType: ["Account"]`
   - Confirmar com o PM se encontrou a conta correta

2. **Coletar dados de uso (Pendo)**
   - Atividade dos últimos 30 dias: `activityQuery` com `entityType: "account"`, `accountId`
   - Features mais usadas: `activityQuery` com `entityType: "feature"`, `accountId`, `sort: ["-numEvents"]`, `limit: 10`
   - Pages mais visitadas: `activityQuery` com `entityType: "page"`, `accountId`, `sort: ["-numEvents"]`, `limit: 10`
   - Frustration events: `activityQuery` com `frustrationMetrics: true`, `accountId`
   - Visitors da conta: `activityQuery` com `entityType: "visitor"`, `accountId`

3. **Coletar session replays**
   - `sessionReplayList` com `accountId`, últimos 14 dias
   - Filtrar sessões com frustration events ou alta atividade
   - Selecionar 2-3 replays mais relevantes para o PM revisar antes da call

4. **Verificar histórico de satisfação**
   - NPS/CSAT respostas da conta (se disponíveis via Pendo)
   - Tickets do Movidesk (se CSV disponível)

5. **Verificar touchpoints anteriores**
   - Buscar em `reports/discovery/` por nome da conta
   - Listar dores e oportunidades já identificadas

6. **Classificar perfil de uso**
   - **Power user**: uso diário, múltiplas features, sessões longas
   - **Regular**: uso semanal, features core
   - **Low-touch**: uso esporádico, poucas features

7. **Gerar perguntas sugeridas**
   - Baseadas em dados (não genéricas)
   - Focadas em comportamento passado (não opinião futura)
   - Template Teresa Torres: "Conte-me sobre a última vez que..."

## Formato de Saída

```
# Discovery Prep — [Nome da Conta]
**Data da entrevista**: [data planejada]
**PM**: [nome]
**Preparado em**: [data atual]

## Perfil da Conta
| Atributo | Valor |
|----------|-------|
| Segmento | [SMB / Mid-Market / Enterprise] |
| Plano | [plano atual] |
| Tempo de cliente | [N meses] |
| Perfil de uso | [Power user / Regular / Low-touch] |
| NPS mais recente | [score ou N/A] |

## Dados de Uso (últimos 30 dias)
| Métrica | Valor | Contexto |
|---------|-------|----------|
| Dias ativos | N/30 | [acima/abaixo da média] |
| Visitors ativos | N | [quantos da conta usam] |
| Sessões totais | N | |
| Features usadas | N de M | |

### Top Features
| Feature | Eventos | Frequência |
|---------|---------|------------|
| [feature 1] | N | [diário/semanal/mensal] |
| [feature 2] | N | |

### Features NÃO usadas (potencial)
- [feature A — 0 eventos, pode ser relevante para a conta]
- [feature B]

## Pontos de Atenção
- [frustration event: N rage clicks em página X]
- [ticket aberto no Movidesk: "descrição"]
- [NPS detrator: comentário]
- [feature com queda de uso]

## Session Replays para Revisar
| # | Data | Duração | Atividade | Frustração | Link |
|---|------|---------|-----------|------------|------|
| 1 | [data] | [min] | [%] | [eventos] | [URL] |
| 2 | [data] | [min] | [%] | [eventos] | [URL] |

## Histórico de Discovery
_Touchpoints anteriores com esta conta_
- [data]: [tipo] — [resumo de dores/oportunidades identificadas]

## Perguntas Sugeridas
_Baseadas nos dados — foco em comportamento passado_

### Warm-up
- "Como tem sido sua rotina usando o Piperun nas últimas semanas?"

### Baseadas em dados
- "[Dado: feature X tem N rage clicks] → Conte-me sobre a última vez que você usou [feature X]. O que estava tentando fazer?"
- "[Dado: feature Y não é usada] → Como você gerencia [problema que Y resolve] hoje?"
- "[Dado: ticket aberto sobre Z] → Me conta como foi a situação que te levou a abrir aquele chamado sobre [Z]"

### Exploratórias
- "Qual parte do seu dia a dia com o Piperun te toma mais tempo?"
- "Tem alguma coisa que você faz fora do Piperun que acha que deveria fazer dentro?"

### Anti-padrões a evitar
- "Você gostaria de ter feature X?" (opinião futura)
- "O que você acha de...?" (opinião, não comportamento)
- "Se a gente fizesse X, você usaria?" (hipotético)
```

## Exemplo

**Input**: "Vou falar amanhã com a conta Acme Corp, me prepara"

**Output**: Briefing completo mostrando que Acme Corp é Mid-Market, usa Piperun 3x/semana com foco em pipeline e automações, teve 5 rage clicks na página de relatórios na última semana, tem 1 ticket aberto sobre exportação de dados, NPS 7 (neutro). Perguntas sugeridas focam em: entender o uso de relatórios (frustração detectada) e explorar por que automações são usadas intensamente (oportunidade de expandir).

## Observações

- Se a conta não for encontrada no Pendo, informar ao PM e fazer prep com dados disponíveis (Movidesk, touchpoints anteriores)
- Priorizar qualidade das perguntas sobre quantidade — 5-7 perguntas focadas são melhor que 15 genéricas
- Sempre incluir a seção "Anti-padrões" — ajuda o PM a evitar vieses durante a entrevista
- Session replays são valiosíssimos — destacar os 2-3 mais relevantes para o PM assistir antes da call
- Se existirem touchpoints anteriores com a conta, destacar o que mudou desde então
