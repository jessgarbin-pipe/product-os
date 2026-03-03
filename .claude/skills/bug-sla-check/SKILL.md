---
name: bug-sla-check
description: "Verifica aderência aos SLAs de bugs P0-P3 do Piperun a partir de dados do Movidesk. Identifica violações, trends e módulos problemáticos. Use SEMPRE que o usuário mencionar: SLA de bug, aderência SLA, bugs atrasados, SLA violado, tempo de resolução, quanto tempo pra resolver, P0, P1, P2, P3, bug SLA report, ou qualquer variação. Também acione quando o PM quiser checar conformidade dos SLAs antes de review ou retrospectiva."
---

# Verificação de SLA de Bugs

Skill para auditar aderência aos SLAs de resolução de bugs definidos no processo de produto Piperun.

## SLAs Definidos

| Severidade | Descrição | SLA Resposta | SLA Resolução |
|-----------|-----------|-------------|---------------|
| **P0** | Clientes perdendo dinheiro. Sistema inoperável | 30min | 4h |
| **P1** | Piperun perdendo dinheiro. Função crítica degradada | 2h | 24h |
| **P2** | Funcionalidade degradada com workaround | 24h | Sprint corrente |
| **P3** | Cosmético ou edge case | Backlog | Próxima sprint |

## Fontes de Dados

### Movidesk (CSV/Excel export)
- Export com: ID, severidade, data de criação, data de primeira resposta, data de resolução, status, módulo
- O PM precisa fornecer o arquivo exportado

## Fluxo de Execução

1. **Receber e processar o CSV**
   - Parsear datas de criação, primeira resposta e resolução
   - Mapear severidade para P0-P3
   - Calcular tempo de resposta e tempo de resolução para cada bug

2. **Verificar SLAs**
   - Para cada bug, comparar tempos reais vs SLA esperado
   - Classificar: dentro do SLA / fora do SLA
   - Calcular tempo excedido para violações

3. **Agregar métricas**
   - % de aderência por severidade (resposta + resolução)
   - Tempo médio de resposta e resolução por severidade
   - Percentil 90 de tempo de resolução
   - Tendência de aderência ao longo do tempo

4. **Identificar padrões de violação**
   - Módulos com pior aderência
   - Dias da semana com mais violações
   - Correlação entre volume e violações

## Formato de Saída

```
# Relatório de SLA de Bugs — Piperun
**Período**: [data início] a [data fim]
**Total de bugs analisados**: [N]

## Aderência Geral
| Severidade | Bugs | SLA Resposta | SLA Resolução | Aderência |
|-----------|------|-------------|---------------|-----------|
| P0 | N | X% dentro | X% dentro | [OK/Alerta] |
| P1 | N | X% dentro | X% dentro | [OK/Alerta] |
| P2 | N | X% dentro | X% dentro | [OK/Alerta] |
| P3 | N | X% dentro | X% dentro | [OK/Alerta] |

## Tempos Médios
| Severidade | Resposta Média | Resolução Média | SLA Resp. | SLA Res. |
|-----------|---------------|----------------|-----------|----------|
| P0 | Xh | Xh | 30min | 4h |
| P1 | Xh | Xh | 2h | 24h |
| P2 | Xh | Xd | 24h | sprint |
| P3 | Xh | Xd | backlog | próx. sprint |

## Violações Ativas (bugs abertos fora do SLA)
| ID | Severidade | Módulo | Criado | Excede SLA por |
|----|-----------|--------|--------|---------------|
| [id] | [sev] | [mod] | [data] | [tempo] |

## Análise por Módulo
| Módulo | Bugs | Aderência Resp. | Aderência Res. |
|--------|------|----------------|----------------|
| [módulo] | N | X% | X% |

## Tendência (últimas 4 semanas)
| Semana | Bugs | Aderência P0-P1 | Aderência P2-P3 |
|--------|------|----------------|----------------|
| [sem] | N | X% | X% |

## Diagnóstico
- [principal causa de violação de SLA]
- [módulo ou equipe com pior aderência]
- [tendência: melhorando ou piorando]

## Recomendações
1. [ação para melhorar aderência de P0/P1]
2. [ação para módulo com pior performance]
3. [ajuste de processo se SLAs são sistematicamente violados]
```

## Exemplo

**Input**: "Estamos respeitando os SLAs de bug?" + [CSV do Movidesk]

**Output**: Aderência geral de 72%. P0: 100% dentro do SLA (2 bugs). P1: 60% dentro (3 de 5 violaram resolução em 24h). P2: 78%. P3: 85%. Módulo de integrações tem pior aderência (55%). Tendência piorando nas últimas 2 semanas.

## Observações

- Se o Movidesk não registra "data de primeira resposta", usar a data do primeiro comentário como proxy
- P0 com 0% de aderência é crítico e deve ser escalado imediatamente — esse não é um problema de processo, é um problema de operação
- Se SLAs estão sendo sistematicamente violados em uma severidade, pode indicar que o SLA está muito agressivo ou que falta capacity no time
