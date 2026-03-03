---
name: nps-analysis
description: "Analisa resultados de NPS do Piperun coletados via Pendo Guides/Polls. Segmenta por promotores, neutros e detratores, identifica padrões nos comentários abertos e acompanha evolução ao longo do tempo. Use SEMPRE que o usuário mencionar: NPS, Net Promoter Score, nota do cliente, satisfação do cliente, promotores, detratores, pesquisa de satisfação, como está o NPS, resultado da pesquisa, ou qualquer variação. Também acione quando o PM quiser entender sentimento geral dos clientes ou preparar dados para review."
---

# Análise de NPS

Skill para analisar resultados de NPS coletados via Pendo Guides/Polls no Piperun.

## Fontes de Dados

### Pendo
- **Guides/Polls**: respostas de NPS (nota 0-10 + comentário aberto)
- Use `guideMetrics` para métricas do guia de NPS (views, completions, dismissals)
- Use `searchEntities` com `itemType: ["Guide"]` e busca por "NPS" para encontrar o guia correto
- Use `activityQuery` com `entityType: "guide"` para dados de interação

### Dados Complementares
- Metabase para cruzar NPS com plano, MRR, segmento
- Pendo visitor/account metadata para segmentação

## Classificação NPS

- **Promotores**: nota 9-10
- **Neutros**: nota 7-8
- **Detratores**: nota 0-6
- **NPS Score**: % promotores - % detratores

## Fluxo de Execução

1. **Coletar respostas do período**
   - Identificar o guia de NPS ativo no Pendo
   - Buscar métricas do guia com `guideMetrics`
   - Extrair notas e comentários

2. **Calcular métricas quantitativas**
   - NPS score atual
   - Distribuição: % promotores, % neutros, % detratores
   - NPS por segmento (plano, tamanho, tempo de cliente)
   - Evolução vs ciclo anterior

3. **Analisar comentários abertos**
   - Agrupar comentários de detratores por tema (bugs, UX, falta de feature, performance, suporte)
   - Agrupar comentários de promotores por tema (entender pontos fortes)
   - Identificar os 3-5 temas mais recorrentes entre detratores

4. **Gerar recomendações**
   - Ações para converter detratores em neutros
   - Ações para converter neutros em promotores
   - Features/módulos mais citados negativamente

## Formato de Saída

```
# Análise de NPS — Piperun
**Período**: [data início] a [data fim]
**Respostas**: [N total] | **Taxa de resposta**: [X%]

## Score
| Métrica | Atual | Anterior | Δ |
|---------|-------|----------|---|
| NPS Score | X | Y | Z |
| Promotores | X% | Y% | |
| Neutros | X% | Y% | |
| Detratores | X% | Y% | |

## NPS por Segmento
| Segmento | NPS | N respostas | Tendência |
|----------|-----|-------------|-----------|
| [plano/segmento] | X | N | ↑↓→ |

## Temas dos Detratores (top 5)
| Tema | Menções | Exemplo de comentário |
|------|---------|----------------------|
| [tema] | N | "[trecho resumido]" |

## Temas dos Promotores (top 3)
| Tema | Menções | Exemplo de comentário |
|------|---------|----------------------|
| [tema] | N | "[trecho resumido]" |

## Plano de Ação
1. **Quick win**: [ação de curto prazo para detratores]
2. **Investigar**: [tema que precisa de discovery]
3. **Reforçar**: [ponto forte a manter/expandir]
```

## Exemplo

**Input**: "Como está o NPS deste trimestre?"

**Output**: NPS de 42 (anterior era 38), com detratores concentrados em reclamações sobre performance do módulo de relatórios (28% das menções). Promotores destacam facilidade de uso do pipeline de vendas. Sugerindo priorizar performance de relatórios no próximo ciclo.

## Observações

- NPS com menos de 50 respostas no ciclo deve ser sinalizado como amostra pequena
- Comentários abertos são mais valiosos que a nota numérica para ação do PM
- Cruzar detratores com dados de uso no Pendo para identificar se são power users frustrados (mais urgente) ou usuários casuais
- Se o guia de NPS não estiver ativo no Pendo, orientar o PM sobre como configurar
