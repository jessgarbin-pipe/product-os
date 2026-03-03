---
name: churn-analysis
description: "Analisa churn e retenção de contas do Piperun, identificando motivos, sinais preditivos e correlação com dados de uso. Cruza Pendo, Metabase e Movidesk. Use SEMPRE que o usuário mencionar: churn, cancelamento, contas perdidas, retenção, taxa de churn, motivos de churn, por que cancelaram, previsão de churn, churn rate, MRR perdido, contas inativas, ou qualquer variação. Também acione quando o PM quiser entender padrões de cancelamento para priorizar ações de retenção."
---

# Análise de Churn

Skill para analisar churn de contas do Piperun, identificando padrões, motivos e sinais preditivos que ajudem o time de produto a agir preventivamente.

## Fontes de Dados

### Metabase (MySQL)
- Dados de churn: contas canceladas, data de cancelamento, motivo registrado
- MRR perdido por conta
- Tempo de vida da conta (lifetime)
- Plano e segmento

### Pendo
- Dados de uso pré-churn: como era o comportamento da conta antes de cancelar
- Use `activityQuery` com `accountId` para histórico de uso de contas específicas
- Use `accountQuery` com `select` para metadata

### Movidesk (CSV)
- Tickets de suporte das contas que churnearam
- Correlação entre volume/severidade de tickets e churn

## Fluxo de Execução

1. **Identificar contas churneadas no período**
   - Consultar Metabase para lista de cancelamentos
   - Se dados de Metabase não estiverem acessíveis, pedir ao PM lista de contas ou CSV

2. **Analisar motivos declarados**
   - Agrupar motivos de cancelamento por categoria
   - Quantificar cada categoria
   - Categorias comuns: preço, falta de feature, mudança para concorrente, empresa fechou, falta de uso, insatisfação com suporte

3. **Analisar comportamento pré-churn**
   - Para contas churneadas, buscar dados de uso dos 90 dias antes do cancelamento
   - Identificar padrão de degradação de uso (queda gradual vs abandono súbito)
   - Comparar com contas ativas saudáveis do mesmo segmento

4. **Identificar sinais preditivos**
   - Queda de DAU > 50% em 2 semanas
   - Nenhum login nos últimos 14 dias
   - NPS detrator no último ciclo
   - Aumento de tickets de suporte
   - Redução de features usadas

5. **Calcular métricas**
   - Churn rate (mensal/trimestral)
   - MRR churn vs MRR expansion
   - Net revenue retention
   - Churn por segmento e plano

## Formato de Saída

```
# Análise de Churn — Piperun
**Período**: [data início] a [data fim]

## Métricas de Churn
| Métrica | Atual | Anterior | Δ |
|---------|-------|----------|---|
| Contas canceladas | N | N | |
| Churn rate (contas) | X% | Y% | |
| MRR perdido | R$ X | R$ Y | |
| Net Revenue Retention | X% | Y% | |

## Motivos de Cancelamento
| Motivo | Contas | % | MRR Perdido |
|--------|--------|---|-------------|
| [motivo 1] | N | X% | R$ X |
| [motivo 2] | N | X% | R$ X |
| ... | | | |

## Churn por Segmento
| Segmento | Churn Rate | Contas | MRR Perdido |
|----------|-----------|--------|-------------|
| [plano/tamanho] | X% | N | R$ X |

## Padrão de Comportamento Pré-Churn
- [padrão 1: ex: "80% das contas tinham queda de uso > 60% nos 30 dias anteriores"]
- [padrão 2: ex: "45% eram detratores no último NPS"]
- [padrão 3: ex: "média de 4 tickets de suporte no último mês"]

## Sinais de Alerta (contas ativas em risco)
| Conta | Sinais Detectados | Health Score | Ação Sugerida |
|-------|-------------------|-------------|---------------|
| [conta] | [sinais] | X | [ação] |

## Recomendações para Produto
1. **Endereçar motivo #1**: [ação específica]
2. **Prevenir**: [mudança no produto para evitar padrão de churn]
3. **Alertar CS**: [critérios para alerta automático]
```

## Exemplo

**Input**: "Por que estamos perdendo contas no plano Pro?"

**Output**: 18 cancelamentos no plano Pro nos últimos 60 dias (churn rate de 4.2%). Motivo #1: migração para concorrente (39%), mencionando falta de integração nativa com WhatsApp. Motivo #2: preço (28%). Padrão pré-churn: 72% tinham queda de uso > 50% nos 30 dias antes e não usavam automações. Recomendação: priorizar integração WhatsApp e criar fluxo de reengajamento para contas Pro com queda de uso.

## Observações

- Churn analysis precisa de dados históricos — se é a primeira vez rodando, os sinais preditivos serão hipóteses a validar
- Distinguir entre churn voluntário (cliente decide sair) e churn involuntário (falha de pagamento)
- MRR churn é mais importante que churn de contas para tomada de decisão (1 conta enterprise que cancela pode pesar mais que 10 starter)
- Contas que fazem downgrade não são churn, mas podem ser early warning — monitorar separadamente
