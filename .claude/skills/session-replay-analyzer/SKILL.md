---
name: session-replay-analyzer
description: "Análise guiada de session replays do Pendo para Continuous Discovery. Encontra e prioriza replays relevantes por conta, visitante ou critérios de frustração, gerando sumários e perguntas de discovery. Use SEMPRE que o usuário mencionar: session replay, replay de sessão, assistir sessão do cliente, shadow session, análise de replay, frustration events, rage clicks, dead clicks, u-turns, replays do Pendo, ver sessão, ou qualquer variação."
---

# Análise Guiada de Session Replay

Skill para encontrar, filtrar e analisar session replays do Pendo como ferramenta de Continuous Discovery. Transforma dados de replay em insights acionáveis e perguntas para entrevistas.

## Princípio Central

Session replays mostram o que o cliente **realmente faz**, não o que ele diz que faz. São a fonte mais pura de dados comportamentais e complementam perfeitamente entrevistas de discovery.

## Fontes de Dados

### Pendo (via MCP tools)
- **Session replays**: `sessionReplayList` — busca, filtra e retorna URLs de replays
- **Activity data**: `activityQuery` — complementa com métricas de uso
- **Account/Visitor info**: `accountQuery`, `visitorQuery` — contexto da conta/visitante
- **Frustration metrics**: `activityQuery` com `frustrationMetrics: true`

### IDs Pendo
Ver CLAUDE.md (seção "Pendo — IDs Importantes")

## Fluxo de Execução

### 1. Definir critérios de busca

O PM pode buscar replays por:
- **Conta específica**: `accountId` — "quero ver replays da Acme Corp"
- **Visitante específico**: `visitorId` — "quero ver sessões do João"
- **Frustração**: sessões com rage clicks, dead clicks, u-turns
- **Feature específica**: `featureIds` — "replays de quem usou automações"
- **Página específica**: `pageIds` — "replays na página de relatórios"
- **Período**: últimos 7/14/31 dias

### 2. Buscar replays no Pendo

Usar `sessionReplayList` com os filtros:
- `subId`: `4732442263093248`
- `startDate` / `endDate`: período desejado
- `accountId` / `visitorId`: se busca por conta/visitante
- `featureIds` / `pageIds`: se busca por feature/página
- `minDuration`: 120000 (2 min mínimo, padrão)
- `minActivityPercentage`: 5 (padrão)

### 3. Priorizar replays para discovery

Ordenar por relevância para discovery:
1. **Alta prioridade**: sessões com frustration events (rage clicks > 0, dead clicks > 0, u-turns > 0)
2. **Média prioridade**: sessões longas (>5 min) com alta atividade (>50%)
3. **Contexto**: sessões em features que o PM quer investigar

### 4. Gerar sumário por replay

Para cada replay selecionado:
- URL direta do replay (para o PM assistir)
- Métricas da sessão (duração, atividade, frustração)
- Contexto da conta/visitante
- Pages/features visitadas (se disponível via activity data)

### 5. Gerar perguntas de discovery baseadas no replay

Transformar observações de replay em perguntas para entrevista:
- Frustração detectada → "No momento X, parece que você teve dificuldade com Y — me conta o que estava tentando fazer"
- Feature ignorada → "Vi que você não usou [feature] — como você resolve [problema que feature resolve] hoje?"
- Workaround observado → "Notei que você copiou dados para [lugar] — me conta sobre esse processo"

## Formato de Saída

### Busca geral
```
# Session Replays — Discovery Analysis
**Período**: [data início] a [data fim]
**Filtros**: [conta/visitante/feature/página]
**Replays encontrados**: [N]

## Replays Prioritários para Discovery

### Replay 1 — Alta Prioridade (Frustração)
| Atributo | Valor |
|----------|-------|
| URL | [link direto do replay] |
| Data | [data] |
| Conta | [nome da conta] |
| Visitante | [ID/email] |
| Duração | [min:seg] |
| Atividade | [%] |
| Rage clicks | [N] |
| Dead clicks | [N] |
| U-turns | [N] |

**Resumo**: [descrição breve do que o replay mostra]
**Pontos de atenção**: [momentos com frustração ou comportamento interessante]
**Perguntas de discovery sugeridas**:
- "[pergunta baseada no replay]"
- "[pergunta baseada no replay]"

### Replay 2 — Média Prioridade
...

## Padrões Observados
- [padrão 1: N replays mostram frustração na mesma feature/página]
- [padrão 2: workaround recorrente observado em N sessões]

## Recomendações para Discovery
1. **Assistir**: Replay [N] antes da próxima entrevista com [conta]
2. **Investigar**: [N] sessões com frustração em [feature/página]
3. **Perguntar**: [sugestão de pergunta baseada nos padrões]
```

### Para conta específica (complementa discovery-prep)
```
# Session Replays — [Nome da Conta]
**Período**: últimos 14 dias
**Replays encontrados**: [N]

## Panorama de Sessões
| Métrica | Valor |
|---------|-------|
| Total de replays | N |
| Com frustration events | N |
| Duração média | X min |
| Atividade média | X% |

## Top 3 Replays para Revisar Antes da Entrevista
[lista com URL, resumo e perguntas sugeridas]
```

## Exemplo

**Input**: "Me mostra replays com rage clicks da última semana"

**Output**: 8 replays encontrados com rage clicks. Top 3: (1) Conta Acme Corp, 12 rage clicks na página de filtros de pipeline — duração 8min, atividade 65%. (2) Conta Beta Inc, 8 rage clicks no módulo de automações — duração 5min. Padrão observado: 5/8 replays têm rage clicks em elementos de filtro. Pergunta sugerida: "Conte-me sobre como você filtra dados no pipeline — o que está buscando?"

## Observações

- Replays são limitados a 31 dias no Pendo — alertar o PM se período solicitado exceder
- Sempre fornecer o URL direto do replay — o PM precisa assistir, não apenas ler o sumário
- Frustration metrics são heurísticas — rage clicks podem ser falsos positivos (clique rápido intencional)
- Session replays são dados sensíveis — não salvar conteúdo de tela, apenas métricas e URLs
- Quando usada junto com `discovery-prep`, focar nos replays da conta específica
- Shadow sessions (observar uso em tempo real) são diferentes de replays (gravações passadas) — esta skill cobre replays
