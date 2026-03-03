---
name: trend-report
description: "Gera relatório de tendências de mercado relevantes para o roadmap do Piperun CRM. Pesquisa blogs, reports de mercado, Product Hunt, lançamentos de concorrentes e movimentos do setor. Use SEMPRE que o usuário mencionar: tendências, trends, o que o mercado está fazendo, novidades de CRM, movimentos do setor, o que está vindo, inovação em CRM, AI em CRM, lançamentos recentes, Product Hunt, ou qualquer variação. Também acione quando o PM quiser contexto de mercado para decisões estratégicas de roadmap."
---

# Relatório de Tendências de Mercado

Skill para pesquisar e consolidar tendências relevantes para o mercado de CRM/SalesTech que impactam o roadmap do Piperun.

## Fontes de Informação

- **Web search**: artigos recentes sobre tendências de CRM e SalesTech
- **Blogs de referência**: Intercom, HubSpot Blog, Pipedrive Blog, ProductLed, OpenView, Tomasz Tunguz
- **Product Hunt**: lançamentos recentes na categoria CRM/Sales
- **Gartner, Forrester, G2**: relatórios de mercado (quando acessíveis)
- **LinkedIn, Twitter/X**: posts de líderes de produto em CRM

## Categorias de Tendência

1. **AI/ML em CRM**: assistentes de venda, previsão, automação inteligente
2. **Product-Led Growth (PLG)**: self-serve, trials, onboarding automatizado
3. **Integrações e Ecossistema**: APIs, marketplaces, embedding
4. **Revenue Operations (RevOps)**: unificação marketing-vendas-CS
5. **Conversational CRM**: WhatsApp, chatbots, omnichannel
6. **Data e Analytics**: dashboards, previsão, analytics avançado
7. **Mobile-first**: apps nativos, experiência mobile
8. **Pricing e Packaging**: modelos usage-based, PLG pricing

## Fluxo de Execução

1. **Pesquisar fontes**
   - Web search por tendências de CRM nos últimos 3-6 meses
   - Buscar lançamentos de concorrentes diretos e indiretos
   - Verificar Product Hunt para startups relevantes

2. **Filtrar por relevância**
   - Priorizar tendências que impactam o mercado brasileiro de CRM
   - Focar em tendências que estão em adoção (não apenas hype)
   - Considerar o tamanho e maturidade da Piperun para viabilidade

3. **Classificar cada tendência**
   - **Maturidade**: emergente / em crescimento / mainstream
   - **Relevância para Piperun**: alta / média / baixa
   - **Urgência**: agora (concorrentes já fizeram) / próximos 6 meses / 12+ meses
   - **Esforço estimado**: pequeno / médio / grande

4. **Gerar recomendações**

## Formato de Saída

```
# Tendências de Mercado — CRM/SalesTech
**Data do relatório**: [data]
**Período coberto**: últimos [N] meses

## Resumo Executivo
[2-3 frases sobre as tendências mais impactantes para o Piperun]

## Tendências por Categoria

### [Categoria 1]
**Tendência**: [descrição]
**Maturidade**: [emergente/crescimento/mainstream]
**Quem está fazendo**: [concorrentes/empresas]
**Relevância para Piperun**: [alta/média/baixa]
**Evidências**: [dados, exemplos, lançamentos]
**Implicação para roadmap**: [o que o Piperun deveria considerar]

### [Categoria 2]
...

## Lançamentos Recentes de Concorrentes
| Concorrente | O que lançou | Data | Impacto |
|-------------|-------------|------|---------|
| [nome] | [feature/mudança] | [data] | [análise] |

## Startups para Observar
| Startup | O que faz | Por que importa |
|---------|-----------|-----------------|
| [nome] | [proposta] | [relevância para Piperun] |

## Ranking de Tendências por Impacto no Piperun
| # | Tendência | Relevância | Urgência | Esforço |
|---|-----------|-----------|----------|---------|
| 1 | [trend] | Alta | Agora | Médio |
| 2 | [trend] | Alta | 6 meses | Grande |
| ... | | | | |

## Recomendações
1. **Agir agora**: [tendência que concorrentes já endereçaram]
2. **Planejar**: [tendência em crescimento para incluir no roadmap]
3. **Observar**: [tendência emergente para acompanhar]
```

## Exemplo

**Input**: "Quais tendências de mercado deveríamos considerar para o roadmap do próximo trimestre?"

**Output**: 3 tendências prioritárias: (1) AI assistente de vendas — HubSpot e Pipedrive já lançaram, urgência alta; (2) Integração nativa com WhatsApp Business API — demanda crescente no BR; (3) Revenue Intelligence com análise preditiva de pipeline — Gong e Clari popularizaram, Salesforce integrou.

## Observações

- Tendências devem ser contextualizadas para o mercado brasileiro — o que funciona nos EUA nem sempre é prioridade aqui
- Diferenciar hype de adoção real — perguntar "algum concorrente direto já implementou?" é um bom filtro
- Relatório de tendências é input para strategy, não decisão final — o PM precisa cruzar com dados de uso e feedback
