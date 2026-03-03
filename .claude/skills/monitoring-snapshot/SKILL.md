---
name: monitoring-snapshot
description: "Gera resumo executivo semanal consolidando TODAS as fontes de monitoramento do Piperun: uso (Pendo), NPS, feedbacks CS, churn, bugs (Movidesk), demandas internas (Slack) e tendências. É a skill mais abrangente de monitoramento. Use SEMPRE que o usuário mencionar: resumo semanal, snapshot, visão geral do monitoramento, como estamos essa semana, pulse do produto, weekly report, resumo executivo, status do produto, overview de monitoramento, ou qualquer variação. Também acione quando o PM quiser preparar review semanal de produto ou enviar update para stakeholders."
---

# Snapshot de Monitoramento Semanal

Skill que consolida todas as fontes de monitoramento em um resumo executivo semanal. É a "master skill" de monitoramento — invoca as demais skills quando necessário.

## Fontes Consolidadas

| # | Fonte | Ferramenta | Dado |
|---|-------|-----------|------|
| 1 | Dados de uso | Pendo + Metabase | DAU, WAU, MAU, features, funis |
| 2 | NPS e pesquisas | Pendo Polls | NPS score, comentários |
| 3 | Feedbacks CS | Movidesk + Pendo + reuniões | Temas qualitativos |
| 4 | Churn e retenção | Metabase + Pendo | Cancelamentos, sinais |
| 5 | Benchmarking | Web research | Movimentos de concorrentes |
| 6 | Tendências | Web research | Tendências de mercado |
| 7 | Bugs e incidentes | Movidesk | Backlog, SLA, severidades |
| 8 | Demandas internas | Slack + formulários | Pedidos de vendas, CS, suporte |

## Fluxo de Execução

1. **Coletar dados de cada fonte**
   - Para cada fonte disponível, coletar as métricas-chave
   - Se dados não estiverem disponíveis para alguma fonte, indicar claramente e seguir com as que existem
   - Priorizar: uso (Pendo) → NPS → bugs → demandas → CS → churn → benchmark → tendências

2. **Para cada fonte, gerar mini-resumo**
   - 2-3 bullets com os highlights mais relevantes
   - Destacar variações significativas vs semana anterior
   - Sinalizar alertas (vermelho) e oportunidades (verde)

3. **Consolidar em resumo executivo**
   - O que está indo bem (max 3 pontos)
   - O que precisa de atenção (max 3 pontos)
   - O que mudou desde a última semana (max 3 pontos)

4. **Gerar recomendações acionáveis**
   - Ações para a próxima semana
   - Inputs para discovery
   - Escalações necessárias

## Skills Relacionadas

Quando o PM pedir detalhamento de uma área específica, direcionar para a skill correta:

| Para detalhar... | Usar skill |
|-----------------|-----------|
| Métricas de uso | `/usage-monitor` |
| Funis específicos | `/funnel-analysis` |
| Retenção por cohort | `/retention-cohort` |
| Adoção de features | `/feature-heatmap` |
| NPS detalhado | `/nps-analysis` |
| Pesquisas pontuais | `/csat-analysis` |
| Feedbacks do CS | `/cs-feedback-synthesis` |
| Health score por conta | `/health-score` |
| Análise de churn | `/churn-analysis` |
| Comparação com concorrente | `/feature-benchmark` ou `/pricing-benchmark` |
| Tendências de mercado | `/trend-report` |
| Dashboard de bugs | `/bug-dashboard` |
| SLA de bugs | `/bug-sla-check` |
| Demandas internas | `/internal-demand-triage` |
| Sentimento agregado | `/sentiment-monitor` |

## Formato de Saída

```
# Snapshot Semanal — Piperun Produto
**Semana**: [data início] a [data fim]
**Preparado por**: [PM] via skill de monitoramento

---

## Resumo Executivo

### O que está indo bem
1. [ponto positivo com dados — ex: "MAU cresceu 5%, maior dos últimos 3 meses"]
2. [ponto positivo]
3. [ponto positivo]

### O que precisa de atenção
1. [alerta com dados — ex: "Bugs P1 dobraram: 3→6, módulo de relatórios concentra 4"]
2. [alerta]
3. [alerta]

### O que mudou
1. [mudança relevante — ex: "NPS caiu de 46 para 41, detratores mencionando performance"]
2. [mudança]
3. [mudança]

---

## Detalhamento por Fonte

### 1. Uso do Produto
| Métrica | Atual | Sem. Anterior | Δ% |
|---------|-------|-------------|-----|
| DAU | N | N | X% |
| WAU | N | N | X% |
| MAU | N | N | X% |
**Destaque**: [1 insight principal]

### 2. NPS e Pesquisas
- NPS atual: [X] ([↑↓→] vs anterior)
- Pesquisas ativas: [N]
**Destaque**: [1 insight principal]

### 3. Feedbacks CS
- Feedbacks processados: [N]
- Tema #1: [tema] ([N] menções)
**Destaque**: [1 insight principal]

### 4. Churn e Retenção
- Cancelamentos na semana: [N]
- Contas em risco (health score < 40): [N]
**Destaque**: [1 insight principal]

### 5. Bugs e Incidentes
- Abertos: [N] (P0: [N], P1: [N], P2: [N], P3: [N])
- Resolvidos na semana: [N]
- SLA compliance: [X%]
**Destaque**: [1 insight principal]

### 6. Demandas Internas
- Novas demandas: [N]
- Tema mais pedido: [tema] ([N] menções de [N] origens)
**Destaque**: [1 insight principal]

### 7. Mercado e Concorrência
- Movimentos relevantes: [se houver]
**Destaque**: [1 insight se relevante, ou "Sem movimentos significativos"]

---

## Ações Recomendadas para Próxima Semana
| # | Ação | Responsável | Prazo | Base |
|---|------|------------|-------|------|
| 1 | [ação] | [quem] | [quando] | [qual fonte/dado justifica] |
| 2 | [ação] | [quem] | [quando] | [dado] |
| 3 | [ação] | [quem] | [quando] | [dado] |

## Inputs para Discovery
- [tema que merece investigação mais profunda]
- [oportunidade identificada cruzando fontes]

## Escalações
- [item que precisa de decisão de liderança, se houver]
```

## Exemplo

**Input**: "Prepara o snapshot da semana"

**Output**: Resumo executivo com 3 positivos (MAU crescendo, NPS estável, 0 P0 na semana), 3 alertas (bugs P1 acumulando no módulo de automações, 2 contas enterprise em risco de churn, demanda crescente de integração WhatsApp de 3 origens diferentes). Recomendações: alocar dev para bugs de automações, CS proativo nas contas em risco, incluir WhatsApp no discovery do próximo ciclo.

## Dados Necessários do PM

Para gerar o snapshot completo, o PM precisa fornecer:
- **Obrigatório**: nada (dados do Pendo são acessados diretamente)
- **Desejável**: CSV do Movidesk (bugs + feedbacks CS da semana)
- **Opcional**: mensagens de Slack com demandas internas, notas de reuniões

Se alguma fonte não estiver disponível, o snapshot é gerado com as fontes que existem e indica claramente quais seções ficaram sem dados.

## Observações

- O snapshot deve caber em uma tela de leitura rápida — se o PM quiser detalhamento, direcionar para as skills específicas
- Comparar SEMPRE com a semana anterior para dar contexto de tendência
- O tom deve ser executivo: dados + insight + ação, sem explicações longas
- Incluir link para drill-down quando relevante ("para detalhar, use `/nps-analysis`")
