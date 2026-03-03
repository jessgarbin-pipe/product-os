---
name: feature-benchmark
description: "Compara features do Piperun com concorrentes específicos do mercado de CRM. Gera matriz feature-a-feature com gaps e oportunidades. Use SEMPRE que o usuário mencionar: benchmark, comparar com concorrente, o que o concorrente tem, gap de feature, feature parity, análise competitiva, como estamos vs mercado, RD Station, HubSpot, Pipedrive, Salesforce, Ploomes, ou qualquer variação. Também acione quando o PM quiser justificar priorização de roadmap com base em posicionamento competitivo."
---

# Benchmark de Features vs Concorrentes

Skill para comparar features do Piperun com concorrentes diretos e indiretos do mercado brasileiro de CRM.

## Concorrentes Mapeados

### Diretos (CRM Brasil)
- **RD Station CRM**: forte em marketing + CRM integrado
- **Ploomes**: foco em vendas complexas B2B
- **Moskit**: CRM simples para PME
- **Agendor**: pipeline visual

### Diretos (CRM Global com presença BR)
- **Pipedrive**: referência em UX de pipeline
- **HubSpot CRM**: freemium forte, ecossistema amplo
- **Salesforce**: enterprise, plataforma extensível

### Indiretos
- **Bitrix24**: CRM + projeto + comunicação
- **Zoho CRM**: suite completa

## Fontes de Informação

- **Web search**: sites dos concorrentes, páginas de features, pricing, changelogs
- **G2, Capterra, B2B Stack**: reviews e comparativos
- **Blogs e artigos**: análises de terceiros

## Fluxo de Execução

1. **Definir escopo da comparação**
   - Perguntar ao PM: quais concorrentes? Quais módulos/features?
   - Se não especificado, comparar os 3 concorrentes diretos mais relevantes

2. **Pesquisar features do concorrente**
   - Usar web search para acessar páginas de features atualizadas
   - Verificar changelogs recentes para features novas
   - Consultar reviews no G2/Capterra para percepção de usuários

3. **Montar matriz comparativa**
   - Listar features por módulo
   - Classificar: Piperun tem / não tem / parcial
   - Classificar: concorrente tem / não tem / parcial
   - Identificar gaps (concorrente tem, Piperun não)
   - Identificar vantagens (Piperun tem, concorrente não)

4. **Analisar implicações**
   - Gaps que aparecem em 2+ concorrentes = tendência de mercado
   - Gaps citados em reviews negativos do Piperun = urgentes
   - Vantagens do Piperun = pontos para reforçar em posicionamento

## Formato de Saída

```
# Benchmark de Features — Piperun vs [Concorrentes]
**Data da pesquisa**: [data]
**Módulo analisado**: [módulo ou "visão geral"]

## Matriz Comparativa
| Feature | Piperun | [Conc. 1] | [Conc. 2] | [Conc. 3] |
|---------|---------|-----------|-----------|-----------|
| [feature] | ✅ / ⚠️ / ❌ | ✅ / ⚠️ / ❌ | ... | ... |

Legenda: ✅ = tem completo | ⚠️ = tem parcial | ❌ = não tem

## Gaps Críticos (concorrentes têm, Piperun não)
| Feature | Quem tem | Impacto estimado | Referência |
|---------|----------|-----------------|------------|
| [feature] | [conc.] | Alto/Médio/Baixo | [fonte] |

## Vantagens Piperun (Piperun tem, concorrentes não)
| Feature | Quem não tem | Potencial de diferenciação |
|---------|-------------|---------------------------|
| [feature] | [conc.] | [análise] |

## Tendências de Mercado
- [tendência 1: feature que múltiplos concorrentes estão adicionando]
- [tendência 2]

## Recomendações para Roadmap
1. **Prioridade alta**: [gap que impacta competitividade]
2. **Oportunidade**: [feature que ninguém tem ainda]
3. **Reforçar**: [vantagem existente para ampliar]

## Fontes
- [links das páginas consultadas]
```

## Exemplo

**Input**: "Como estamos vs Pipedrive no módulo de automações?"

**Output**: Matriz comparando 12 features de automação. Piperun tem vantagem em triggers customizáveis e automação de tarefas. Pipedrive tem vantagem em automação de email sequencial e integração com Zapier nativa. Gap crítico: Pipedrive lançou AI para sugerir automações em dez/2025, Piperun não tem nada similar.

## Observações

- Informações de concorrentes mudam rapidamente — sempre datar a pesquisa e recomendar atualização periódica
- Não assumir que "ter a feature" significa qualidade equivalente — sinalizar quando a implementação do concorrente é claramente superior ou inferior
- Reviews de usuários (G2, Capterra) são tão valiosos quanto a página de features do concorrente
- Benchmark não é argumento isolado para priorização — cruzar com dados de uso e feedback para decidir
