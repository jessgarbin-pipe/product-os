---
name: bug-dashboard
description: "Gera visão consolidada de bugs abertos no Piperun por severidade, idade e módulo a partir de dados exportados do Movidesk. Use SEMPRE que o usuário mencionar: bugs abertos, dashboard de bugs, quantos bugs temos, bugs por módulo, backlog de bugs, bug report, situação dos bugs, dívida técnica, incidentes abertos, ou qualquer variação. Também acione quando o PM quiser entender o estado do backlog de bugs para priorização ou review."
---

# Dashboard de Bugs

Skill para consolidar dados de bugs e incidentes do Movidesk em uma visão acionável para o time de produto.

## Fontes de Dados

### Movidesk (CSV/Excel export)
- O PM precisa fornecer o arquivo exportado do Movidesk
- Campos esperados: ID, assunto, descrição, categoria, severidade/prioridade, data de criação, status, módulo/área, cliente, data de resolução

## Severidades (SLA Piperun)

Ver tabela completa de Bug SLAs P0-P3 no CLAUDE.md (seção "Padrões de Severidade de Bugs").

## Fluxo de Execução

1. **Receber e processar o CSV do Movidesk**
   - Parsear o arquivo (adaptar ao formato específico do export)
   - Normalizar campos de severidade para P0-P3
   - Calcular idade de cada bug (dias desde criação)
   - Identificar módulo/área de cada bug

2. **Gerar métricas agregadas**
   - Total de bugs abertos por severidade
   - Total por módulo/área
   - Distribuição de idade (< 7d, 7-30d, 30-90d, > 90d)
   - Taxa de resolução (resolvidos/criados no período)
   - Bugs violando SLA

3. **Identificar padrões**
   - Módulos com mais bugs acumulados
   - Severidades com pior taxa de resolução
   - Tendência: backlog crescendo ou diminuindo?
   - Clientes mais impactados

4. **Gerar recomendações**

## Formato de Saída

```
# Dashboard de Bugs — Piperun
**Data**: [data] | **Fonte**: Movidesk export [período]

## Resumo
| Métrica | Valor |
|---------|-------|
| Total abertos | N |
| P0 abertos | N |
| P1 abertos | N |
| P2 abertos | N |
| P3 abertos | N |
| Criados no período | N |
| Resolvidos no período | N |
| Taxa de resolução | X% |

## Bugs por Módulo
| Módulo | Total | P0 | P1 | P2 | P3 | Idade Média |
|--------|-------|----|----|----|----|-------------|
| [módulo] | N | N | N | N | N | Xd |

## Bugs Violando SLA
| ID | Severidade | Módulo | Idade | SLA Esperado | Excedido por |
|----|-----------|--------|-------|-------------|-------------|
| [id] | P0 | [mod] | Xd | 4h | Yd |

## Distribuição por Idade
| Faixa | Count | % |
|-------|-------|---|
| < 7 dias | N | X% |
| 7-30 dias | N | X% |
| 30-90 dias | N | X% |
| > 90 dias | N | X% |

## Tendência
- Backlog está [crescendo/estável/diminuindo]
- [N] bugs novos/semana vs [N] resolvidos/semana
- Módulo com mais acúmulo: [nome]

## Top 5 Bugs Mais Antigos
| ID | Severidade | Módulo | Assunto | Idade |
|----|-----------|--------|---------|-------|
| [id] | [sev] | [mod] | [assunto] | Xd |

## Recomendações
1. **Urgente**: [P0/P1 violando SLA]
2. **Dívida técnica**: [módulo com acúmulo crônico]
3. **Quick wins**: [P3 antigos que podem ser fechados]
```

## Exemplo

**Input**: "Qual a situação dos bugs abertos?" + [arquivo CSV do Movidesk]

**Output**: 87 bugs abertos. 2 P0 abertos há mais de 4h (violando SLA). Módulo de relatórios concentra 31% dos bugs. Backlog cresceu 15% no último mês. Recomendação: alocar sprint dedicada a bugs de relatórios e resolver P0 imediatamente.

## Observações

- Se o CSV não tiver campo de severidade padronizado (P0-P3), pedir ao PM as regras de mapeamento ou inferir pela classificação do Movidesk
- Bugs sem módulo definido devem ser marcados como "Não classificado" — isso também é um insight (falta de categorização)
- Se o PM pedir visão de tendência, precisa de exports de múltiplos períodos ou de um export com datas de criação e resolução
