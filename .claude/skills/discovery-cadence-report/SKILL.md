---
name: discovery-cadence-report
description: "Gera relatório de cadência e insights acumulados de Continuous Discovery. Acompanha touchpoints por PM, cobertura do painel, distribuição por formato/segmento e consolida padrões emergentes. Use SEMPRE que o usuário mencionar: relatório de discovery, cadência de entrevistas, resumo de discovery, quantos touchpoints fiz, weekly discovery review, review de discovery, cadência semanal, como estou no discovery, status do discovery, ou qualquer variação."
---

# Relatório de Cadência e Insights Acumulados de Discovery

Skill para acompanhar a cadência de Continuous Discovery (meta: >=1 touchpoint/semana por PM) e consolidar insights acumulados de múltiplos touchpoints.

## Princípio Central

Continuous Discovery só funciona se for realmente contínuo. Esta skill monitora a disciplina do hábito e sintetiza o que os touchpoints estão revelando.

## Fontes de Dados

### Touchpoint logs
- Diretório `reports/discovery/touchpoint-*.md` — output de cada touchpoint registrado
- Parse dos campos: data, PM, tipo, cliente, segmento, dores, oportunidades

### Painel de clientes
- `reports/discovery/panel.json` — composição e status do painel

### Pendo (complementar)
- Dados de uso para contextualizar insights de discovery
- Verificar se dores identificadas em entrevistas aparecem nos dados quantitativos

### IDs Pendo
Ver CLAUDE.md (seção "Pendo — IDs Importantes")

## Fluxo de Execução

1. **Coletar todos os touchpoints do período**
   - Listar arquivos `reports/discovery/touchpoint-*.md`
   - Filtrar pelo período solicitado (semana, mês, trimestre)
   - Extrair metadata: data, PM, tipo, cliente, segmento

2. **Calcular métricas de cadência**
   - Touchpoints por semana (meta: >=1)
   - Semanas com touchpoint vs sem touchpoint
   - Distribuição por formato (entrevista, protótipo, replay, shadow)
   - Distribuição por segmento (SMB, Mid-Market, Enterprise)
   - Clientes únicos contactados / total do painel

3. **Consolidar insights (cross-touchpoint)**
   - Extrair dores de todos os touchpoints do período
   - Agrupar dores por similaridade temática
   - Contar frequência de cada tema (em quantos touchpoints aparece)
   - Extrair oportunidades e agrupar por conexão com OST
   - Identificar comportamentos recorrentes

4. **Verificar viés**
   - Concentração de segmento: >60% dos touchpoints em 1 segmento
   - Concentração de formato: >80% entrevista sem replay ou protótipo
   - Concentração de cliente: mesmo cliente >3x sem rotação
   - Concentração de tema: perguntas sempre sobre o mesmo assunto

5. **Gerar relatório**

## Formato de Saída

### Relatório semanal
```
# Discovery Review — Semana [N/YYYY]
**Período**: [segunda] a [sexta]
**PM**: [nome]

## Cadência
| Métrica | Valor | Meta | Status |
|---------|-------|------|--------|
| Touchpoints esta semana | N | >= 1 | [OK / ABAIXO] |
| Touchpoints no mês | N | >= 4 | [OK / ABAIXO] |
| Clientes contactados (mês) | N/N | >= 50% do painel | [OK / ABAIXO] |

## Touchpoints da Semana
| # | Data | Tipo | Cliente | Segmento |
|---|------|------|---------|----------|
| 1 | [data] | [tipo] | [conta] | [seg] |
| ... | | | | |

## Distribuição
### Por Formato
| Formato | Mês | % |
|---------|-----|---|
| Entrevista | N | X% |
| Teste de protótipo | N | X% |
| Session replay | N | X% |
| Shadow session | N | X% |

### Por Segmento
| Segmento | Mês | % | Painel % |
|----------|-----|---|----------|
| SMB | N | X% | X% |
| Mid-Market | N | X% | X% |
| Enterprise | N | X% | X% |

## Insights Acumulados (últimas 4 semanas)

### Top Dores Identificadas
| # | Dor | Freq. | Segmentos | Módulo |
|---|-----|-------|-----------|--------|
| 1 | [tema] | N touchpoints | [segs] | [mod] |
| 2 | [tema] | N touchpoints | [segs] | [mod] |

### Top Oportunidades
| # | Oportunidade | Freq. | Conexão OST |
|---|-------------|-------|-------------|
| 1 | [oportunidade] | N touchpoints | [sim/não — qual] |
| 2 | [oportunidade] | N touchpoints | [sim/não] |

### Comportamentos Recorrentes
- [comportamento observado em N+ touchpoints independentes]
- [workaround comum entre clientes de segmentos diferentes]

## Alertas de Viés
- [alerta se houver concentração de segmento/formato/cliente/tema]

## Recomendação para Próxima Semana
1. [quem entrevistar — baseado em cobertura do painel]
2. [formato sugerido — baseado em distribuição]
3. [tema a explorar — baseado em dor emergente]
```

### Relatório mensal (mais detalhado)
```
# Discovery Monthly Review — [Mês/YYYY]

## Resumo Executivo
- [N] touchpoints realizados em [N] semanas
- [N] clientes únicos contactados de [N] no painel
- Top insight: [insight mais relevante do mês]

## Cadência Semanal
| Semana | Touchpoints | Formato | Segmento |
|--------|-------------|---------|----------|
| Sem 1 | N | [tipos] | [segs] |
| Sem 2 | N | [tipos] | [segs] |
| Sem 3 | N | [tipos] | [segs] |
| Sem 4 | N | [tipos] | [segs] |

## Síntese de Descobertas
[Narrativa consolidada dos insights do mês, agrupando dores, oportunidades e padrões comportamentais em uma visão coerente]

## Conexões com Estratégia
| Descoberta | Conexão OST | Ação sugerida |
|-----------|------------|---------------|
| [descoberta] | [opportunity/solution] | [próximo passo] |

## Evolução do Painel
- Clientes adicionados: [N]
- Clientes rotacionados: [N]
- Próxima rotação devida: [data]
```

## Exemplo

**Input**: "Como estou no discovery essa semana?"

**Output**: Semana 9/2026: 1 touchpoint realizado (entrevista com Acme Corp, Mid-Market) — cadência OK. Mês: 3 touchpoints, 3/12 clientes contactados (25%, meta 50%). Alerta: nenhum touchpoint com Enterprise no mês. Top dor acumulada: "Dificuldade com relatórios gerenciais" (apareceu em 3/3 touchpoints). Sugestão: entrevistar cliente Enterprise esta semana, usar session replay para variar formato.

## Observações

- Se não houver touchpoints registrados, a skill não tem dados — sugerir ao PM registrar via `discovery-touchpoint-log`
- Relatório semanal é rápido e focado em cadência; mensal é mais profundo com síntese de insights
- Insights acumulados são pré-análise — para análise profunda cross-touchpoint, sugerir o agent `discovery-pattern-finder`
- Alertas de viés são sugestões, não críticas — o PM pode ter razões válidas para concentrar em 1 segmento temporariamente
- A cadência de >=1/semana é um mínimo — não penalizar quem faz mais
