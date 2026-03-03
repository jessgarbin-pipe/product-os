---
name: pricing-benchmark
description: "Compara planos, pricing e packaging do Piperun com concorrentes de CRM. Analisa posicionamento de preço, features por plano e modelo de monetização. Use SEMPRE que o usuário mencionar: pricing, preço do concorrente, comparar planos, packaging, quanto custa, modelo de cobrança, pricing page, tier, plano free, freemium, ou qualquer variação. Também acione quando o PM quiser revisar o pricing do Piperun ou entender posicionamento de preço no mercado."
---

# Benchmark de Pricing e Packaging

Skill para comparar estratégia de pricing e packaging do Piperun com concorrentes diretos, analisando posicionamento, proposta de valor por tier e oportunidades.

## Fontes de Informação

- **Pricing pages**: páginas públicas de preço dos concorrentes
- **Web search**: artigos de comparação, reviews com menção a preço
- **G2, Capterra, B2B Stack**: informações de pricing reportadas por usuários

## Fluxo de Execução

1. **Definir escopo**
   - Quais concorrentes comparar (padrão: RD Station CRM, Pipedrive, HubSpot, Ploomes)
   - Foco em algum tier específico ou visão completa

2. **Coletar dados de pricing**
   - Preço por usuário/mês (mensal e anual)
   - Features incluídas por plano
   - Limites (contatos, automações, usuários, storage)
   - Modelo de cobrança (por usuário, por conta, flat fee, usage-based)
   - Plano free/trial se existir

3. **Montar comparativo**
   - Tabela de preço por tier equivalente
   - Mapeamento de features mais valiosas por tier
   - Análise de custo por feature-chave

4. **Analisar posicionamento**
   - Onde o Piperun se posiciona no espectro de preço
   - Value-for-money: features entregues vs preço cobrado
   - Gaps de packaging: features que o mercado inclui num tier mais baixo

## Formato de Saída

```
# Benchmark de Pricing — CRM Brasil
**Data**: [data da pesquisa]

## Comparativo de Preço (por usuário/mês, cobrança anual)
| Plano | Piperun | [Conc. 1] | [Conc. 2] | [Conc. 3] |
|-------|---------|-----------|-----------|-----------|
| Básico | R$ X | R$ X | R$ X | R$ X |
| Intermediário | R$ X | R$ X | R$ X | R$ X |
| Avançado | R$ X | R$ X | R$ X | R$ X |
| Enterprise | R$ X | R$ X | R$ X | R$ X |

## Modelo de Cobrança
| Aspecto | Piperun | [Conc. 1] | [Conc. 2] |
|---------|---------|-----------|-----------|
| Modelo | por usuário | por usuário | freemium + per seat |
| Free tier | Não | Não | Sim (limitado) |
| Trial | X dias | Y dias | Z dias |
| Desconto anual | X% | Y% | Z% |

## Features por Tier (mapeamento)
| Feature-chave | Piperun (tier) | [Conc.] (tier) | Análise |
|--------------|----------------|----------------|---------|
| Automações | Pro | Básico | Gap: concorrente inclui antes |
| API | Enterprise | Pro | Gap |
| Relatórios custom | Pro | Pro | Paridade |

## Posicionamento
- Piperun está no [percentil] de preço do mercado
- [X] features justificam o preço vs concorrentes mais baratos
- [Y] features são entregues por concorrentes mais baratos — gap de packaging

## Oportunidades
1. [oportunidade de ajuste de packaging]
2. [oportunidade de novo tier ou add-on]
3. [oportunidade de diferenciação por modelo de cobrança]

## Fontes
- [links consultados]
```

## Exemplo

**Input**: "Como nosso pricing compara com Pipedrive e HubSpot?"

**Output**: Piperun está 20% acima do Pipedrive e 10% abaixo do HubSpot no tier intermediário. Pipedrive inclui automações no plano básico (Piperun só no Pro). HubSpot oferece free tier com CRM completo. Oportunidade: criar tier de entrada mais acessível ou incluir automações básicas no plano inicial.

## Observações

- Preços podem variar por região e moeda — normalizar sempre para BRL quando possível
- Descontos para pagamento anual e volume de licenças impactam a comparação — anotar condições
- Pricing muda frequentemente — datar toda pesquisa e recomendar revisão trimestral
- Não focar apenas em preço absoluto — analisar custo-benefício considerando as features entregues
