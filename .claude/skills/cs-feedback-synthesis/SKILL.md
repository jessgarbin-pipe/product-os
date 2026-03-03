---
name: cs-feedback-synthesis
description: "Gera síntese semanal dos feedbacks qualitativos recebidos pelo time de CS da Piperun, a partir de dados do Movidesk (CSV), Pendo e anotações de reuniões. Agrupa por tema, módulo e sentimento. Use SEMPRE que o usuário mencionar: feedback do CS, feedback qualitativo, o que o CS está ouvindo, reclamações de clientes, pedidos do CS, voz do cliente, customer success feedback, síntese de feedbacks, resumo do CS, ou qualquer variação. Também acione quando o PM quiser preparar input de CS para discovery ou planejamento."
---

# Síntese de Feedback Qualitativo do CS

Skill para consolidar e sintetizar feedbacks qualitativos que o time de CS da Piperun recebe, transformando dados dispersos em insights acionáveis para produto.

## Fontes de Dados

### Movidesk (fonte primária)
- Export CSV/Excel com tickets, comentários e classificações
- O PM precisa fornecer o arquivo exportado do Movidesk
- Campos relevantes: assunto, descrição, categoria, cliente, data, status

### Pendo
- Feedbacks in-app coletados via polls ou guides
- Use `searchEntities` com `itemType: ["Guide"]` para encontrar polls de feedback
- Comentários abertos em pesquisas NPS/CSAT

### Anotações de reuniões
- O PM pode colar anotações de reuniões de CS diretamente
- Atas de QBR (Quarterly Business Review)
- Notas de calls com clientes

## Fluxo de Execução

1. **Receber os dados**
   - Pedir ao PM o CSV do Movidesk (período: última semana ou mês)
   - Complementar com dados do Pendo se disponíveis
   - Se o PM tiver notas de reuniões, incluir

2. **Processar e categorizar**
   - Extrair feedbacks do CSV (campo de descrição/comentário)
   - Classificar cada feedback por:
     - **Módulo**: qual área do produto (pipeline, automações, relatórios, integrações, etc.)
     - **Tipo**: bug report, feature request, dúvida de uso, reclamação de UX, performance
     - **Sentimento**: positivo, neutro, negativo
     - **Urgência**: alta (impacta operação), média (incômodo), baixa (nice-to-have)

3. **Agrupar e quantificar**
   - Contar feedbacks por módulo e tipo
   - Identificar os 5 temas mais recorrentes
   - Identificar tendências (temas novos vs recorrentes)

4. **Contextualizar com dados de uso**
   - Para os módulos mais citados, cruzar com dados de uso do Pendo
   - Identificar se reclamações vêm de power users (mais urgente) ou ocasionais

## Formato de Saída

```
# Síntese de Feedback CS — Piperun
**Período**: [data início] a [data fim]
**Fontes**: Movidesk ([N] tickets) | Pendo ([N] respostas) | Reuniões ([N] notas)
**Total de feedbacks processados**: [N]

## Top 5 Temas
| # | Tema | Módulo | Menções | Sentimento | Tendência |
|---|------|--------|---------|------------|-----------|
| 1 | [tema] | [módulo] | N | Negativo | ↑ Crescendo |
| 2 | [tema] | [módulo] | N | Negativo | → Estável |
| ... | | | | | |

## Distribuição por Módulo
| Módulo | Total | Bugs | Requests | UX | Performance |
|--------|-------|------|----------|----|-------------|
| [módulo] | N | N | N | N | N |

## Feedbacks Novos (não apareciam antes)
- [feedback novo 1 — contexto]
- [feedback novo 2 — contexto]

## Citações Representativas
> "[citação de detrator sobre tema 1]" — Cliente [segmento]
> "[citação de detrator sobre tema 2]" — Cliente [segmento]
> "[citação de promotor]" — Cliente [segmento]

## Recomendações para Produto
1. **Prioridade alta**: [tema que impacta operação de clientes]
2. **Investigar**: [tema recorrente que precisa de discovery]
3. **Quick win**: [ajuste pequeno com impacto em satisfação]
```

## Exemplo

**Input**: "Faz a síntese dos feedbacks do CS da última semana" + [arquivo CSV do Movidesk anexo]

**Output**: 47 feedbacks processados. Tema #1: "Lentidão ao carregar lista de leads" (12 menções, sentimento negativo, tendência crescente). Tema #2: "Pedido de integração com WhatsApp Business API" (8 menções, feature request recorrente). Recomendação: priorizar investigação de performance no módulo de leads.

## Observações

- O CSV do Movidesk pode ter formatos diferentes dependendo da configuração — adaptar o parsing ao formato recebido
- Feedbacks de reuniões são geralmente menos estruturados — pedir ao PM que cole as notas e processar com mais cuidado
- Feedbacks repetidos do mesmo cliente devem ser contados como 1 tema (deduplicar por conta)
- Sempre separar bugs confirmados de percepções de bug (cliente acha que é bug mas é comportamento esperado)
