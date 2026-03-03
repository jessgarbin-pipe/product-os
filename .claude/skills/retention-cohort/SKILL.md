---
name: retention-cohort
description: "Gera análise de coortes de retenção do Piperun por período e segmento usando Pendo e Metabase. Use SEMPRE que o usuário mencionar: retenção, retention, cohort, coorte, D1/D7/D30, usuários voltaram, engajamento recorrente, stickiness, retenção por plano, retenção por segmento, ou qualquer variação. Também acione quando o PM quiser entender se mudanças no produto estão melhorando a retenção."
---

# Análise de Cohort de Retenção

Skill para gerar análises de coortes que mostram como diferentes grupos de usuários retêm ao longo do tempo no Piperun.

## Fontes de Dados

### Pendo
- **Visitors**: atividade por visitante ao longo do tempo
- **Accounts**: atividade por conta para retenção B2B
- Use `activityQuery` com `period: "weekly"` ou `"daily"` e `group: ["visitorId"]` ou `["accountId"]`
- Use `productEngagementScore` para métricas de stickiness (DAU/MAU, WAU/MAU)

### Metabase (MySQL)
- Data de criação da conta (para definir a coorte)
- Plano e segmento do cliente (para segmentação)

## Fluxo de Execução

1. **Definir parâmetros da cohort**
   - Granularidade: semanal (padrão) ou mensal
   - Evento de retenção: login, uso de feature core, ou qualquer evento específico
   - Período: últimas 12 semanas ou 6 meses (padrão)
   - Segmentação: por plano, tamanho de conta, ou feature

2. **Montar a matriz de cohort**
   - Cada linha = uma coorte (ex: "Contas criadas na semana de 01/jan")
   - Cada coluna = semana/mês relativo (Semana 0, Semana 1, ..., Semana N)
   - Célula = % de usuários/contas da coorte que retornaram naquele período

3. **Calcular métricas derivadas**
   - Retenção média por semana/mês
   - Ponto de estabilização (onde a curva achata)
   - Comparação entre coortes recentes vs antigas

4. **Identificar padrões**
   - Coortes que retêm melhor/pior → correlacionar com releases ou mudanças
   - Segmentos com retenção acima/abaixo da média
   - Impacto de features específicas na retenção

## Formato de Saída

```
# Cohort de Retenção — Piperun
**Período**: [início] a [fim] | **Granularidade**: [semanal/mensal]
**Evento**: [qual evento define "retorno"]

## Matriz de Retenção
| Cohort    | S0   | S1   | S2   | S3   | S4   | ... |
|-----------|------|------|------|------|------|-----|
| Sem 01/01 | 100% | 72%  | 58%  | 51%  | 48%  |     |
| Sem 08/01 | 100% | 68%  | 55%  | 49%  |      |     |
| ...       |      |      |      |      |      |     |

## Indicadores
- **Retenção S1 média**: X%
- **Ponto de estabilização**: Semana Y (~Z%)
- **Stickiness (DAU/MAU)**: W%

## Insights
1. [insight sobre tendência geral]
2. [insight sobre coortes outlier]
3. [insight sobre impacto de mudanças no produto]

## Recomendação
[O que o PM deveria investigar ou testar para melhorar retenção]
```

## Exemplo

**Input**: "Como está a retenção dos últimos 3 meses por plano?"

**Output**: Matriz de coortes mensais mostrando que contas do plano Enterprise retêm 78% no mês 2 enquanto plano Starter retém apenas 35%, sugerindo gap de onboarding no plano básico.

## Observações

- Retenção B2B deve ser analisada por conta (accountId), não por visitante individual
- Coortes com menos de 30 contas são pouco confiáveis — indicar o N de cada coorte
- Se o PM pedir stickiness, usar `productEngagementScore` do Pendo com os parâmetros corretos de numerator/denominator
