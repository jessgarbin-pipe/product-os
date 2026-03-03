---
name: health-score
description: "Calcula e analisa health score por conta do Piperun, combinando dados de uso (Pendo), satisfação (NPS/CSAT) e suporte (Movidesk). Use SEMPRE que o usuário mencionar: health score, saúde da conta, risco de churn, contas em risco, customer health, score de engajamento, contas saudáveis, contas críticas, ou qualquer variação. Também acione quando o PM quiser identificar contas que precisam de atenção proativa ou entender o estado geral da base."
---

# Health Score por Conta

Skill para calcular um score composto de saúde para cada conta do Piperun, combinando múltiplas dimensões de engajamento e satisfação.

## Fontes de Dados

### Pendo (uso do produto)
- Use `activityQuery` com `entityType: "account"`, `group: ["accountId"]` para métricas por conta
- Métricas: `numEvents`, `numMinutes`, `daysActive`, `uniqueVisitorCount`
- Use `accountQuery` com `select` para metadata da conta

### Pendo (NPS/CSAT)
- Última nota NPS por conta (via account metadata ou polls)
- Respostas CSAT recentes

### Movidesk (suporte)
- CSV exportado com tickets por conta
- Campos: quantidade de tickets, severidade, tempo de resolução, tickets abertos

## Composição do Health Score

O health score é uma média ponderada de 4 dimensões, cada uma pontuada de 0 a 100:

| Dimensão | Peso | Fonte | O que mede |
|----------|------|-------|------------|
| **Uso** | 35% | Pendo | DAU, frequência, profundidade de uso |
| **Adoção** | 25% | Pendo | % de features core adotadas |
| **Satisfação** | 25% | Pendo NPS | Última nota NPS (ou CSAT) |
| **Suporte** | 15% | Movidesk | Volume e severidade de tickets |

### Cálculo por Dimensão

**Uso (0-100)**:
- `daysActive` nos últimos 30 dias: 20+ dias = 100, 10-19 = 70, 5-9 = 40, <5 = 10
- Ponderado por `numMinutes` e `uniqueVisitorCount` da conta

**Adoção (0-100)**:
- Definir lista de features core (ex: pipeline, contatos, atividades, automações, relatórios)
- % de features core usadas pela conta nos últimos 30 dias
- 100% features = 100, escala linear

**Satisfação (0-100)**:
- NPS 9-10 = 100, NPS 7-8 = 60, NPS 0-6 = 20
- Se não tem NPS recente (> 90 dias), usar 50 (neutro)

**Suporte (0-100)**:
- 0 tickets abertos = 100
- 1-2 tickets baixa severidade = 80
- 3+ tickets ou qualquer P0/P1 = 30
- Inverso: mais tickets = score mais baixo

### Classificação Final

| Score | Classificação | Cor | Ação |
|-------|--------------|-----|------|
| 80-100 | Saudável | Verde | Manter, buscar expansão |
| 60-79 | Atenção | Amarelo | Monitorar, engajar proativamente |
| 40-59 | Risco | Laranja | Intervenção do CS |
| 0-39 | Crítico | Vermelho | Ação urgente, risco de churn |

## Fluxo de Execução

1. **Coletar dados por conta**
   - Pendo: métricas de uso e adoção dos últimos 30 dias
   - NPS: última resposta de cada conta
   - Movidesk: CSV com tickets abertos e histórico recente

2. **Calcular score por dimensão**
   - Aplicar as regras acima para cada conta

3. **Calcular health score composto**
   - Média ponderada das 4 dimensões

4. **Gerar análise**

## Formato de Saída

```
# Health Score — Piperun
**Data de cálculo**: [data]
**Contas analisadas**: [N]

## Distribuição
| Classificação | Contas | % |
|--------------|--------|---|
| Saudável (80+) | N | X% |
| Atenção (60-79) | N | X% |
| Risco (40-59) | N | X% |
| Crítico (<40) | N | X% |

## Contas Críticas (ação urgente)
| Conta | Score | Uso | Adoção | NPS | Suporte | Alerta Principal |
|-------|-------|-----|--------|-----|---------|-----------------|
| [nome] | X | X | X | X | X | [motivo] |

## Contas que Melhoraram
| Conta | Score Atual | Score Anterior | Δ |
|-------|-------------|----------------|---|

## Contas que Pioraram
| Conta | Score Atual | Score Anterior | Δ |
|-------|-------------|----------------|---|

## Insights
1. [padrão identificado nas contas críticas]
2. [correlação entre dimensões]
3. [tendência geral da base]

## Ações Recomendadas
- **CS**: [contas para contato prioritário]
- **Produto**: [módulo/feature impactando scores]
- **Suporte**: [tickets prioritários]
```

## Exemplo

**Input**: "Quais contas estão em risco de churn?"

**Output**: 12 de 230 contas ativas estão em estado crítico (score < 40). Padrão comum: baixo uso do módulo de automações (dimensão de adoção < 20) combinado com tickets recentes sobre performance. Contas críticas são majoritariamente do plano Pro com 6-12 meses de contrato.

## Observações

- Os pesos e thresholds devem ser calibrados com base no histórico real de churn da Piperun — os valores aqui são ponto de partida
- Contas novas (< 60 dias) devem ter health score calculado apenas com uso e suporte (sem NPS que ainda não existe)
- Se o CSV do Movidesk não estiver disponível, calcular com 3 dimensões e indicar a limitação
- Health score deve ser recalculado semanalmente para detectar tendências
