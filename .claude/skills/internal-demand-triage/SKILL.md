---
name: internal-demand-triage
description: "Triagem e categorização de demandas internas vindas de vendas, CS e suporte via Slack e formulários. Agrupa pedidos similares, identifica padrões e sugere priorização. Use SEMPRE que o usuário mencionar: demandas internas, pedidos do comercial, pedidos do CS, pedidos do suporte, backlog de pedidos, o que os times estão pedindo, triagem de demandas, requests internos, ou qualquer variação. Também acione quando o PM quiser organizar demandas espalhadas em canais de Slack ou preparar input para planejamento."
---

# Triagem de Demandas Internas

Skill para organizar, categorizar e priorizar demandas internas que chegam ao time de produto da Piperun via Slack (canais diversos) e formulários.

## Fontes de Dados

### Slack
- Demandas espalhadas em vários canais (sem canal dedicado)
- O PM precisa colar ou encaminhar as mensagens relevantes
- Ou fornecer screenshot/export das mensagens

### Formulários
- Se houver formulário estruturado, o PM fornece o export (CSV/Excel)

### Contexto do PM
- O PM pode complementar com contexto verbal sobre demandas que ouviu em reuniões

## Fluxo de Execução

1. **Receber as demandas**
   - O PM cola as mensagens do Slack, encaminha screenshots, ou fornece CSV do formulário
   - Processar cada mensagem como uma demanda individual

2. **Categorizar cada demanda**
   - **Origem**: Vendas / CS / Suporte / Liderança / Outro
   - **Tipo**: Feature request / Melhoria / Bug / Integração / Usabilidade / Performance
   - **Módulo**: qual área do produto é impactada
   - **Urgência declarada**: como o solicitante posicionou (urgente, importante, nice-to-have)
   - **Impacto estimado**: quantos clientes/revenue impactado (se mencionado)

3. **Agrupar demandas similares**
   - Identificar demandas que pedem a mesma coisa com palavras diferentes
   - Contar quantas vezes cada tema aparece e de quantas origens distintas
   - Tema que aparece em 3+ origens diferentes = sinal forte

4. **Cruzar com dados existentes**
   - Verificar se a demanda já existe no backlog (PM confirma)
   - Verificar se há dados de uso no Pendo que suportem ou contradigam
   - Verificar se aparece nos feedbacks do CS ou NPS

5. **Sugerir priorização**
   - Demandas com múltiplas origens + impacto em revenue = prioridade alta
   - Demandas de uma única pessoa sem evidência de impacto = backlog

## Formato de Saída

```
# Triagem de Demandas Internas — Piperun
**Período**: [data início] a [data fim]
**Total de demandas processadas**: [N]
**Fontes**: Slack ([N]) | Formulário ([N]) | Outro ([N])

## Demandas Agrupadas por Tema
| # | Tema | Tipo | Módulo | Menções | Origens | Impacto |
|---|------|------|--------|---------|---------|---------|
| 1 | [tema] | Feature | [mod] | N | Vendas, CS | Alto |
| 2 | [tema] | Melhoria | [mod] | N | Suporte | Médio |
| ... | | | | | | |

## Distribuição por Origem
| Origem | Demandas | % |
|--------|----------|---|
| Vendas | N | X% |
| CS | N | X% |
| Suporte | N | X% |

## Distribuição por Tipo
| Tipo | Demandas | % |
|------|----------|---|
| Feature request | N | X% |
| Melhoria | N | X% |
| Bug | N | X% |
| Integração | N | X% |

## Top 5 Demandas por Prioridade Sugerida
| # | Demanda | Motivo da Prioridade | Origens | Ação Sugerida |
|---|---------|---------------------|---------|---------------|
| 1 | [demanda] | [justificativa] | [N origens] | Discovery |
| 2 | [demanda] | [justificativa] | [N origens] | Avaliar |
| ... | | | | |

## Demandas já no Backlog
- [demanda X] — reforçar prioridade (mais N pedidos)
- [demanda Y] — sem novos pedidos

## Demandas sem Evidência Suficiente
- [demanda de 1 pessoa, sem impacto claro — manter observação]

## Citações Relevantes
> "[mensagem original do Slack]" — [Fulano], Vendas
> "[mensagem original do Slack]" — [Ciclano], CS

## Recomendações
1. [tema #1: sugerir próximo passo — discovery, one-pager, etc]
2. [tema #2: sugerir próximo passo]
3. [padrão geral: ex: "40% das demandas são sobre integrações — considerar strategy dedicada"]
```

## Exemplo

**Input**: "[PM cola 15 mensagens de Slack de diferentes canais]"

**Output**: 15 demandas agrupadas em 8 temas. Tema #1: "Integração com WhatsApp Business" (4 menções de 3 origens — Vendas, CS, Suporte). Tema #2: "Relatório de pipeline por equipe" (3 menções, Vendas). 2 demandas já estão no backlog. 3 demandas são de origem única sem evidência de impacto amplo. Recomendação: abrir discovery para integração WhatsApp e validar demanda de relatórios com dados do Pendo.

## Observações

- Mensagens de Slack são informais — extrair a demanda real por trás de reclamações ou pedidos vagos
- Vendedores tendem a dizer "todos os clientes pedem" — sempre questionar e buscar evidência quantitativa
- Demandas do suporte frequentemente são bugs disfarçados de feature requests — classificar corretamente
- O PM deve confirmar a triagem antes de ela se tornar input formal para planejamento
