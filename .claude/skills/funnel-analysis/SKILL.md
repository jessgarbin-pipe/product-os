---
name: funnel-analysis
description: "Analisa funis de conversão e drop-off por feature ou fluxo no Piperun usando dados do Pendo. Use SEMPRE que o usuário mencionar: funil, conversão, drop-off, abandono, taxa de conversão, onde os usuários desistem, fluxo do usuário, user flow, onboarding funnel, activation funnel, setup funnel, ou qualquer variação. Também acione quando o PM quiser entender gargalos em fluxos específicos do produto."
---

# Análise de Funil

Skill para analisar funis de conversão dentro do Piperun, identificando onde os usuários desistem e quais etapas têm maior atrito.

## Fontes de Dados

### Pendo
- **Pages**: sequência de pageviews para mapear fluxos
- **Features**: interações em cada etapa do funil
- **Activity queries**: dados de eventos com filtro por período e segmento

Use `activityQuery` com:
- `entityType: "page"` ou `"feature"` para as etapas do funil
- `itemIds`: lista de IDs das pages/features que compõem o funil
- `group: ["visitorId"]` para contar unique visitors por etapa
- `dateRange`: período de análise

## Fluxo de Execução

1. **Definir o funil**
   - Perguntar ao PM qual fluxo quer analisar (ou identificar pelo contexto)
   - Mapear as etapas do funil como pages ou features no Pendo
   - Se o PM não souber os IDs, usar `searchEntities` para encontrar

2. **Coletar dados por etapa**
   - Para cada etapa, buscar `uniqueVisitorCount` no período
   - Calcular conversão entre etapas consecutivas (etapa N+1 / etapa N)
   - Identificar a etapa com maior drop-off

3. **Segmentar se relevante**
   - Por plano do cliente
   - Por período (comparar semanas)
   - Por dispositivo ou origem

4. **Diagnosticar gargalos**
   - Etapas com conversão < 50% são alertas vermelhos
   - Etapas com conversão entre 50-70% são alertas amarelos
   - Sugerir hipóteses para os drop-offs encontrados

## Formato de Saída

```
# Análise de Funil — [Nome do Fluxo]
**Período**: [data início] a [data fim]

## Visão do Funil
| Etapa | Visitantes | Conversão | Drop-off |
|-------|-----------|-----------|----------|
| [etapa 1] | N | 100% | — |
| [etapa 2] | N | X% | Y% |
| [etapa N] | N | X% | Y% |

## Gargalo Principal
**Etapa**: [nome]
**Drop-off**: [X%] dos usuários abandonam aqui
**Hipóteses**:
1. [hipótese baseada no contexto do fluxo]
2. [hipótese baseada em padrões comuns de UX]

## Comparativo (se disponível)
| Período | Conversão total |
|---------|----------------|
| Atual   | X%             |
| Anterior| Y%             |

## Próximos Passos
- [sugestão acionável 1]
- [sugestão acionável 2]
```

## Exemplo

**Input**: "Onde os usuários estão desistindo no fluxo de criação de automação?"

**Output**: Funil de 5 etapas mostrando que 62% dos usuários abandonam na etapa de configuração de trigger, com hipóteses de que a interface tem muitas opções e sugerindo simplificar o happy path.

## Observações

- Se o funil não estiver instrumentado no Pendo, informar ao PM quais eventos precisam ser criados
- Funis com menos de 100 visitantes na primeira etapa podem não ser estatisticamente relevantes — sinalizar isso
- Sempre comparar com período anterior quando disponível para dar contexto de tendência
