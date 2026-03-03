---
name: feature-heatmap
description: "Gera mapa de adoção de features do Piperun mostrando % da base usando cada feature, frequência e profundidade de uso. Usa dados do Pendo. Use SEMPRE que o usuário mencionar: adoção de feature, feature adoption, quais features são mais usadas, mapa de calor, heatmap de features, features subutilizadas, features populares, uso por feature, ou qualquer variação. Também acione quando o PM quiser priorizar investimento em features existentes ou identificar candidates para deprecação."
---

# Mapa de Calor de Features

Skill para mapear a adoção e profundidade de uso de cada feature do Piperun, ajudando o PM a entender onde investir e o que considerar deprecar.

## Fontes de Dados

### Pendo
- **Features**: clicks, unique visitors, frequência por feature
- Use `activityQuery` com `entityType: "feature"`, `group: ["featureId"]`
- Use `searchEntities` com `itemType: ["Feature"]` para listar features disponíveis
- Use `productEngagementScore` com `featureIds` para adoção específica

## Fluxo de Execução

1. **Listar features instrumentadas**
   - Usar `searchEntities` para obter todas as features do app
   - Agrupar por módulo/área do produto quando possível

2. **Coletar métricas por feature**
   - `uniqueVisitorCount`: quantos visitantes únicos usaram
   - `uniqueAccountCount`: quantas contas usaram
   - `numEvents`: total de interações
   - Calcular: `% adoção = contas que usaram / total de contas ativas`
   - Calcular: `frequência = eventos / visitantes únicos`

3. **Classificar features**
   - **Power features** (alta adoção + alta frequência): core do produto
   - **Underused** (baixa adoção + alta frequência): boas features escondidas
   - **One-shot** (alta adoção + baixa frequência): usadas uma vez e abandonadas
   - **Candidates para depreciação** (baixa adoção + baixa frequência)

4. **Gerar visualização**

## Formato de Saída

```
# Mapa de Adoção de Features — Piperun
**Período**: [data início] a [data fim]
**Base ativa**: [N contas]

## Quadrante de Adoção

### Power Features (alta adoção, alta frequência)
| Feature | Adoção | Freq/usuário | Eventos |
|---------|--------|-------------|---------|
| [nome]  | X%     | Y/sem       | N       |

### Features Escondidas (baixa adoção, alta frequência)
| Feature | Adoção | Freq/usuário | Eventos |
|---------|--------|-------------|---------|
| [nome]  | X%     | Y/sem       | N       |

### One-Shot (alta adoção, baixa frequência)
| Feature | Adoção | Freq/usuário | Eventos |
|---------|--------|-------------|---------|
| [nome]  | X%     | Y/sem       | N       |

### Candidates para Revisão (baixa adoção, baixa frequência)
| Feature | Adoção | Freq/usuário | Eventos |
|---------|--------|-------------|---------|
| [nome]  | X%     | Y/sem       | N       |

## Top 10 Features por Adoção
[ranking das 10 mais usadas]

## Bottom 10 Features por Adoção
[ranking das 10 menos usadas]

## Insights
1. [insight sobre distribuição de uso]
2. [insight sobre features escondidas com potencial]
3. [insight sobre features para investigar depreciação]

## Recomendações
- [ação 1 — ex: melhorar discovery da feature X]
- [ação 2 — ex: investigar abandono da feature Y]
```

## Thresholds de Classificação

Os thresholds devem ser calibrados com base na realidade do Piperun, mas como ponto de partida:
- **Alta adoção**: > 30% das contas ativas
- **Baixa adoção**: < 10% das contas ativas
- **Alta frequência**: > 3 usos/semana por usuário
- **Baixa frequência**: < 1 uso/semana por usuário

Perguntar ao PM se esses thresholds fazem sentido para o contexto antes de classificar.

## Exemplo

**Input**: "Quais features estão sendo subutilizadas?"

**Output**: Mapa mostrando que "Templates de Email" tem apenas 8% de adoção mas frequência alta (5x/sem) entre quem usa, sugerindo problema de discovery. Já "Relatórios Custom" tem 4% de adoção e 0.3x/sem de frequência, candidate para revisão ou depreciação.

## Observações

- Adoção deve ser medida por conta (accountId), não por visitante, pois no B2B a unidade que importa é a empresa
- Features recém-lançadas (< 4 semanas) devem ser marcadas como "em rampa" e não classificadas no quadrante ainda
- Considerar sazonalidade — features de faturamento podem ter picos no início do mês
