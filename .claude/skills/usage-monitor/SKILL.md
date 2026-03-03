---
name: usage-monitor
description: "Gera dashboard de métricas de uso do produto Piperun com dados do Pendo e Metabase. Use SEMPRE que o usuário mencionar: métricas de uso, DAU, WAU, MAU, sessões, tempo médio, engagement, adoção, usage analytics, dashboard de uso, como está o uso do produto, quantos usuários ativos, ou qualquer variação. Também acione quando o PM quiser entender tendências de uso ou preparar dados para review semanal."
---

# Monitor de Uso do Produto

Skill para consolidar e analisar métricas de uso do Piperun, cruzando dados do Pendo (eventos, features, pages) com queries do Metabase (dados de negócio).

## Fontes de Dados

### Pendo
- **Pages**: pageviews, unique visitors, tempo na página
- **Features**: clicks, unique visitors, frequência de uso
- **Visitors**: DAU, WAU, MAU, sessões, tempo médio
- **Accounts**: accounts ativos, distribuição de uso por conta

Para acessar dados do Pendo, use a ferramenta `activityQuery` com os parâmetros:
- `entityType`: "page", "feature", "visitor", ou "account"
- `dateRange`: período desejado (ex: `{range: "relative", lastNDays: 30}`)
- `appId` e `subId`: identificadores da aplicação Piperun no Pendo

### Metabase
- Dados de negócio armazenados em MySQL
- Acesso via queries SQL quando necessário para cruzar dados de uso com dados de negócio (ex: plano do cliente, MRR, segmento)

## Fluxo de Execução

1. **Coletar métricas core do Pendo**
   - DAU, WAU, MAU dos últimos 30 dias (usar `activityQuery` com `entityType: "visitor"`, `period: "daily"`)
   - Sessões médias por visitante (usar `group: ["visitorId"]`)
   - Tempo médio por sessão

2. **Identificar tendências**
   - Comparar período atual vs anterior (ex: últimos 7 dias vs 7 dias anteriores)
   - Destacar variações > 10% (positivas ou negativas)
   - Calcular taxa de crescimento de uso

3. **Segmentar por dimensão relevante**
   - Por plano (se disponível via Metabase)
   - Por tamanho de conta (small/mid/enterprise)
   - Por feature mais usada

4. **Gerar output**

## Formato de Saída

SEMPRE use este template:

```
# Dashboard de Uso — Piperun
**Período**: [data início] a [data fim]

## Métricas Core
| Métrica | Atual | Anterior | Δ% |
|---------|-------|----------|-----|
| DAU     |       |          |     |
| WAU     |       |          |     |
| MAU     |       |          |     |
| Sessões/usuário |  |      |     |
| Tempo médio (min) | |     |     |

## Tendências
- [tendência 1 com contexto]
- [tendência 2 com contexto]

## Alertas
- [métricas com variação > 10%]

## Recomendação para o PM
[1-2 frases sobre o que investigar ou agir]
```

## Exemplo

**Input**: "Como está o uso do produto essa semana?"

**Output**: Dashboard com DAU/WAU/MAU comparando semana atual vs anterior, destacando que o módulo de automações teve queda de 15% em uso e sugerindo investigar se há correlação com bugs recentes no Movidesk.

## Observações

- Quando o Pendo não retornar dados suficientes, indicar claramente quais métricas estão indisponíveis e sugerir fontes alternativas
- Sempre contextualizar números absolutos com percentuais e tendências — números isolados não ajudam na tomada de decisão
- Se o PM pedir um recorte específico (ex: "uso da feature X"), adaptar a query focando nessa dimensão em vez de gerar o dashboard completo
