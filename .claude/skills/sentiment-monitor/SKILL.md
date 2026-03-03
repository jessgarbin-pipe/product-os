---
name: sentiment-monitor
description: "Análise de sentimento agregada do Piperun cruzando NPS (Pendo), feedbacks CS (Movidesk), suporte e dados de churn. Gera índice de sentimento geral e por módulo. Use SEMPRE que o usuário mencionar: sentimento dos clientes, como os clientes estão se sentindo, percepção do produto, satisfação geral, sentimento por módulo, mood dos clientes, pulse check, voz do cliente consolidada, ou qualquer variação. Também acione quando o PM quiser uma visão holística de como os clientes percebem o produto."
---

# Monitor de Sentimento Agregado

Skill para consolidar sentimento dos clientes a partir de múltiplas fontes, gerando um índice de sentimento geral e por módulo/área do Piperun.

## Fontes de Dados

### Pendo
- **NPS**: notas e comentários (via guides/polls)
- **CSAT**: pesquisas pontuais
- **Feedback in-app**: respostas de polls de feedback
- Use `guideMetrics` e `searchEntities` para acessar

### Movidesk (CSV)
- Tickets de suporte: volume, sentimento dos comentários, severidade
- Feedbacks qualitativos do CS

### Dados de uso (Pendo)
- Correlação entre sentimento e engagement
- Use `activityQuery` para métricas de uso por conta

## Índice de Sentimento

Score de 0-100 composto por:

| Componente | Peso | Fonte | Métrica |
|-----------|------|-------|---------|
| NPS normalizado | 35% | Pendo | (NPS + 100) / 2 |
| CSAT médio normalizado | 25% | Pendo | (média CSAT / 5) × 100 |
| Sentimento de tickets | 20% | Movidesk | % tickets com tom positivo/neutro |
| Tendência de uso | 20% | Pendo | Variação de MAU (positiva = bom) |

## Fluxo de Execução

1. **Coletar dados de cada fonte**
   - NPS: último ciclo disponível
   - CSAT: pesquisas recentes (últimos 30 dias)
   - Movidesk: CSV de tickets do período
   - Uso: dados de atividade do Pendo

2. **Classificar sentimento por fonte**
   - NPS: promotores (+), neutros (0), detratores (-)
   - Comentários abertos: classificar por sentimento (positivo/neutro/negativo)
   - Tickets: inferir sentimento pelo tom e severidade
   - Uso: aumento = positivo, queda = negativo

3. **Agregar por módulo**
   - Mapear cada feedback/ticket para o módulo do produto
   - Calcular sentimento por módulo
   - Identificar módulos com sentimento divergente (ex: uso crescente mas sentimento negativo = frustração)

4. **Calcular índice geral**
   - Média ponderada dos componentes
   - Comparar com período anterior

5. **Identificar dissonâncias**
   - Módulo com alto uso + sentimento negativo = urgente (usuários frustrados mas dependentes)
   - Módulo com baixo uso + sentimento positivo = oportunidade (bom produto, falta discovery)

## Formato de Saída

```
# Monitor de Sentimento — Piperun
**Data**: [data] | **Período analisado**: últimos [N] dias

## Índice de Sentimento Geral
**Score**: [X]/100 | **Tendência**: [↑↓→] vs período anterior

| Componente | Score | Peso | Contribuição |
|-----------|-------|------|-------------|
| NPS | X/100 | 35% | X |
| CSAT | X/100 | 25% | X |
| Tickets | X/100 | 20% | X |
| Tendência uso | X/100 | 20% | X |

## Sentimento por Módulo
| Módulo | Sentimento | NPS | Tickets (neg) | Uso | Diagnóstico |
|--------|-----------|-----|--------------|-----|-------------|
| [módulo] | X/100 | ↑↓ | N | ↑↓ | [ex: "frustração crescente"] |

## Temas Positivos (o que os clientes gostam)
1. [tema + evidência + fonte]
2. [tema + evidência + fonte]

## Temas Negativos (o que os clientes reclamam)
1. [tema + evidência + fonte + módulo]
2. [tema + evidência + fonte + módulo]

## Dissonâncias Detectadas
- **[módulo]**: uso alto + sentimento negativo → [interpretação]
- **[módulo]**: uso baixo + sentimento positivo → [interpretação]

## Variação vs Período Anterior
| Aspecto | Anterior | Atual | Δ |
|---------|----------|-------|---|
| Índice geral | X | Y | Z |
| Temas negativos | N | N | |
| Módulo mais problemático | [mod] | [mod] | |

## Recomendações
1. **Prioridade**: [módulo com pior sentimento + alto uso]
2. **Oportunidade**: [módulo com bom sentimento para expandir]
3. **Investigar**: [dissonância que precisa de discovery]
```

## Exemplo

**Input**: "Como os clientes estão se sentindo com o produto?"

**Output**: Índice de sentimento: 62/100 (queda de 5 pontos). NPS subiu levemente (44→46) mas tickets negativos cresceram 30%, concentrados no módulo de automações. Dissonância: automações tem o maior uso (78% das contas) mas o pior sentimento — indica frustração com feature core. Recomendação: sprint de qualidade focada em automações.

## Observações

- Sentimento é subjetivo — o índice serve como proxy e trigger de investigação, não como verdade absoluta
- Quando uma fonte de dados não está disponível, calcular com as fontes que existem e indicar a limitação
- Sentimento de tickets pode ser difícil de classificar automaticamente — usar heurísticas simples (palavras-chave negativas, severidade) e sinalizar que é aproximação
