---
name: discovery-panel-manager
description: "Gerencia o painel fixo de 10-15 clientes para Continuous Discovery por PM. Controla composição, cobertura, rotação trimestral e sugere novos clientes. Use SEMPRE que o usuário mencionar: painel de clientes, clientes do discovery, rotação de painel, meu painel, quem entrevistar, cadência de discovery, painel fixo, panel de discovery, gerenciar painel, adicionar cliente ao painel, remover do painel, ou qualquer variação."
---

# Gestão do Painel de Clientes para Discovery

Skill para gerenciar o painel fixo de 10-15 clientes que cada PM mantém para Continuous Discovery. Controla composição por segmento, acompanha cobertura, alerta sobre rotação trimestral e sugere novos clientes.

## Princípio Central

Cada PM deve manter um painel fixo de 10-15 clientes voluntários, com representação de SMB, Mid-Market e Enterprise. Parte do painel rotaciona trimestralmente para evitar viés.

## Fontes de Dados

### Painel local
- Arquivo de painel em `reports/discovery/panel.json`
- Contém: lista de clientes, segmento, data de inclusão, último touchpoint

### Pendo (via MCP tools)
- Dados de uso e engagement para sugerir novos clientes
- NPS/CSAT para identificar promotores e detratores
- Account metadata para segmentação

### Touchpoints registrados
- Buscar em `reports/discovery/touchpoint-*.md` para atualizar último contato
- Calcular cobertura e cadência por cliente

### IDs Pendo
Ver CLAUDE.md (seção "Pendo — IDs Importantes")

## Estrutura do Painel (`reports/discovery/panel.json`)

```json
{
  "pm": "nome-do-pm",
  "lastUpdated": "2026-03-02",
  "panel": [
    {
      "accountId": "acme-corp",
      "accountName": "Acme Corp",
      "contact": "João Silva",
      "contactRole": "Gerente Comercial",
      "segment": "Mid-Market",
      "addedDate": "2026-01-15",
      "lastTouchpoint": "2026-02-25",
      "touchpointCount": 4,
      "rotationDue": false,
      "notes": "Power user de automações, aberto a testes de protótipo"
    }
  ],
  "rotationHistory": [
    {
      "accountId": "old-client",
      "removedDate": "2026-01-01",
      "reason": "Rotação trimestral",
      "replacedBy": "acme-corp"
    }
  ]
}
```

## Fluxo de Execução

### Comando: Ver painel atual
1. Ler `reports/discovery/panel.json`
2. Calcular métricas: total, distribuição por segmento, cobertura, clientes com rotação devida
3. Listar touchpoints recentes de cada cliente (buscar em `reports/discovery/`)
4. Apresentar status formatado

### Comando: Adicionar cliente ao painel
1. Validar que o painel não excede 15 clientes
2. Verificar se o segmento está balanceado (alerta se >60% em 1 segmento)
3. Buscar dados da conta no Pendo para enriquecer o registro
4. Adicionar ao `panel.json`

### Comando: Remover/rotacionar cliente
1. Mover o cliente para `rotationHistory`
2. Sugerir substituição do mesmo segmento
3. Atualizar `panel.json`

### Comando: Quem entrevistar?
1. Calcular quem está há mais tempo sem touchpoint
2. Verificar se há clientes do painel ainda não contactados no período
3. Priorizar: clientes com comportamento interessante no Pendo (anomalias, frustração)
4. Sugerir 2-3 clientes com justificativa

### Comando: Verificar rotação trimestral
1. Identificar clientes com `addedDate` > 90 dias
2. Sugerir quais manter (high-value para discovery) e quais rotar
3. Para os que devem sair, sugerir substitutos do Pendo

## Formato de Saída

### Status do painel
```
# Painel de Discovery — [PM]
**Última atualização**: [data]
**Clientes no painel**: [N] / 15

## Composição por Segmento
| Segmento | Clientes | % | Meta |
|----------|----------|---|------|
| SMB | N | X% | 30-40% |
| Mid-Market | N | X% | 30-40% |
| Enterprise | N | X% | 20-30% |

## Status dos Clientes
| # | Conta | Segmento | Último Touchpoint | Dias sem contato | Rotação devida |
|---|-------|----------|-------------------|------------------|----------------|
| 1 | [conta] | [seg] | [data] | N dias | [Sim/Não] |
| ... | | | | | |

## Cobertura do Período
- **Esta semana**: [N] touchpoints ([N/N] clientes contactados)
- **Este mês**: [N] touchpoints ([N/N] clientes contactados)
- **Meta semanal**: >= 1 touchpoint

## Alertas
- [cliente X: 30+ dias sem contato]
- [rotação trimestral devida para N clientes]
- [painel com 0 clientes Enterprise — sub-representado]

## Sugestão: Quem entrevistar esta semana?
1. **[Cliente A]** — [justificativa baseada em dados: anomalia de uso, ticket recente, etc.]
2. **[Cliente B]** — [justificativa]
```

## Sugestões de Novos Clientes

Quando sugerir novos clientes para o painel, usar critérios:

1. **Segmento sub-representado**: priorizar segmentos com <30% do painel
2. **Comportamento interessante no Pendo**:
   - Contas com frustration events frequentes (rage clicks, dead clicks)
   - Contas com padrão de uso atípico (muito alto ou muito baixo)
   - Contas que pararam de usar feature específica
3. **NPS extremo**:
   - Detratores (0-6): entender o que frustra
   - Promotores (9-10): entender o que encanta
4. **Diversidade de use case**: garantir que o painel cobre diferentes formas de usar o Piperun

## Exemplo

**Input**: "Quem devo entrevistar essa semana?"

**Output**: Sugere Cliente A (Mid-Market, 15 dias sem contato, teve 8 rage clicks na página de automações na última semana) e Cliente B (Enterprise, 21 dias sem contato, NPS caiu de 9 para 6 no último ciclo). Justificativa baseada em dados reais do Pendo.

## Observações

- O arquivo `panel.json` é a fonte de verdade do painel — sempre ler antes de modificar
- Se `panel.json` não existir, perguntar ao PM os dados do painel e criar o arquivo
- Rotação trimestral não é automática — a skill sugere, o PM decide
- Nunca incluir mais de 15 clientes no painel (limite do framework Teresa Torres para manter qualidade)
- Balanceamento de segmento é sugestão, não regra rígida — o PM pode ter razões para concentrar em 1 segmento temporariamente
