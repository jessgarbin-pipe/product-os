---
name: csat-analysis
description: "Analisa resultados de CSAT e pesquisas pontuais do Piperun coletadas via Pendo Polls. Categoriza respostas abertas, identifica padrões por fluxo/feature e acompanha evolução. Use SEMPRE que o usuário mencionar: CSAT, Customer Satisfaction, pesquisa pontual, feedback in-app, poll, enquete, pesquisa pós-feature, pesquisa de usabilidade, resultado da pesquisa, ou qualquer variação. Também acione quando o PM quiser entender satisfação com uma feature específica ou fluxo recém-lançado."
---

# Análise de CSAT e Pesquisas Pontuais

Skill para analisar pesquisas de satisfação pontuais (CSAT, pesquisas pós-feature, pesquisas de usabilidade) coletadas via Pendo Polls no Piperun.

## Fontes de Dados

### Pendo
- **Polls**: respostas de pesquisas pontuais (escalas, múltipla escolha, texto aberto)
- Use `guideMetrics` para métricas do poll específico
- Use `searchEntities` com `itemType: ["Guide"]` para encontrar polls
- Polls no Pendo podem ter diferentes formatos: escala 1-5, sim/não, NPS, texto aberto

## Diferença entre NPS e CSAT

| | NPS | CSAT |
|---|---|---|
| Escopo | Satisfação geral com o produto | Satisfação com interação/feature específica |
| Escala | 0-10 | Geralmente 1-5 ou emoji |
| Frequência | Periódica (trimestral) | Contextual (pós-ação) |
| Skill | `/analise-nps` | Esta skill |

## Fluxo de Execução

1. **Identificar a pesquisa alvo**
   - Buscar polls recentes no Pendo via `searchEntities`
   - Se o PM especificar qual pesquisa, usar diretamente
   - Se não, listar pesquisas disponíveis para o PM escolher

2. **Coletar e agregar respostas**
   - Total de respostas vs total de impressões (taxa de resposta)
   - Distribuição das respostas (se escala: média, mediana, desvio)
   - Se tem pergunta aberta: agrupar por tema

3. **Segmentar resultados**
   - Por plano/segmento (via account metadata do Pendo)
   - Por comportamento prévio (power users vs novos)
   - Temporal: respostas da primeira semana vs semanas seguintes

4. **Contextualizar**
   - Cruzar com dados de uso da feature avaliada
   - Comparar CSAT com pesquisas anteriores do mesmo tipo

## Formato de Saída

```
# Análise de Pesquisa — [Nome da Pesquisa]
**Tipo**: CSAT / Pesquisa pós-feature / Usabilidade
**Período**: [data início] a [data fim]
**Respostas**: [N] | **Taxa de resposta**: [X%]

## Resultado Quantitativo
| Resposta | Count | % |
|----------|-------|---|
| [opção 1] | N | X% |
| [opção 2] | N | X% |
| ... | | |

**Média**: X/5 | **Mediana**: Y/5

## Resultado por Segmento
| Segmento | Média | N |
|----------|-------|---|
| [seg 1] | X | N |
| [seg 2] | X | N |

## Temas das Respostas Abertas
| Tema | Menções | Sentimento | Exemplo |
|------|---------|------------|---------|
| [tema] | N | Positivo/Negativo | "[resumo]" |

## Correlação com Uso
- Usuários satisfeitos usam a feature [X] vezes/semana
- Usuários insatisfeitos usam [Y] vezes/semana
- [insight sobre correlação]

## Recomendação
[Ação sugerida com base nos resultados]
```

## Exemplo

**Input**: "Como foi a pesquisa sobre o novo editor de emails?"

**Output**: CSAT médio de 3.8/5 com 142 respostas. 65% classificaram como "Bom" ou "Excelente". Respostas abertas negativas concentradas em "templates limitados" (23 menções) e "lentidão ao carregar" (18 menções). Contas enterprise deram nota 15% menor que contas starter.

## Observações

- Taxa de resposta < 5% pode indicar problema no targeting do poll ou poll fatigue
- Pesquisas contextuais (aparecem após uso da feature) têm dados mais ricos que pesquisas broadcast
- Se a pesquisa tem múltiplas perguntas, analisar cada uma separadamente e buscar correlações
