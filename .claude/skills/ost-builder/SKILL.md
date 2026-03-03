---
name: ost-builder
description: "Cria e mantém o Opportunity Solution Tree (OST) do Piperun conectando OKRs > Oportunidades > Soluções. Alimentado semanalmente por discovery, atualizado mensalmente com resultados reais. Use SEMPRE que o usuário mencionar: opportunity solution tree, OST, árvore de oportunidades, conectar oportunidade ao objetivo, soluções para objetivo, criar OST, ver árvore, atualizar OST, ou qualquer variação."
---

# Opportunity Solution Tree (OST) — Piperun

Skill para criar e manter o Opportunity Solution Tree (Teresa Torres) conectando OKRs (topo) > Oportunidades (meio) > Soluções (base). Framework vivo, alimentado semanalmente por discovery e atualizado mensalmente com resultados reais.

## Conceito

O OST é uma árvore hierárquica:
```
[Objetivo do OKR]
  ├── [Oportunidade 1]
  │   ├── [Solução 1a] (status: ideação)
  │   └── [Solução 1b] (status: shipped, resultado: +5% retenção)
  ├── [Oportunidade 2]
  │   └── [Solução 2a] (status: validada)
  └── [Oportunidade 3] ← órfã (sem touchpoints há 45 dias)
```

**NÃO é um exercício trimestral top-down.** É alimentado continuamente por discovery e dados de produto.

## Fontes de Dados

| Fonte | Localização | O que alimenta |
|-------|-------------|---------------|
| OKRs | `reports/strategy/okrs/okrs-YYYY-QN.md` | Raízes da árvore (objetivos) |
| Oportunidades | `reports/backlog/opportunities/OPP-*.md` | Nodos do meio |
| Discovery | `reports/discovery/touchpoint-*.md` | Evidências para oportunidades |
| Pattern Finder | Agent `discovery-pattern-finder` | Candidates para novas oportunidades |
| Pendo | MCP tools | Impacto medido pós-ship |
| Ideação | `reports/strategy/ideation/idea-*.md` | Soluções propostas |

## Storage

### Index: `reports/strategy/ost/ost-index.json`

```json
{
  "version": "1.0",
  "lastUpdated": "2026-03-15",
  "quarter": "2026-Q2",
  "trees": [
    {
      "objective": "Título do objetivo",
      "objectiveSlug": "slug-do-objetivo",
      "okrRef": "OKR Obj 1",
      "file": "ost-slug-do-objetivo.md",
      "opportunityCount": 5,
      "solutionCount": 8,
      "lastUpdated": "2026-03-15"
    }
  ]
}
```

### Árvore por objetivo: `reports/strategy/ost/ost-[objective-slug].md`

```markdown
# OST — [Título do Objetivo]

**OKR Ref**: Objetivo [N] — [Quarter]
**Última atualização**: [data]
**Oportunidades**: [N] | **Soluções**: [N]

---

## Oportunidade 1: [Título]
- **ID**: OPP-2026-001 (link para `reports/backlog/opportunities/`)
- **Status**: ativa | órfã | resolvida
- **Evidência**: [N] touchpoints, [N] fontes
- **RICE**: [score] | **Strategic Priority**: [score]
- **Últimos touchpoints**: [lista dos 3 mais recentes]

### Soluções
| ID | Título | Status | RICE | Resultado real |
|----|--------|--------|------|---------------|
| SOL-001 | [título] | ideação | - | - |
| SOL-002 | [título] | shipped | 8.5 | +5% retenção D7 |

---

## Oportunidade 2: [Título]
...

---

## Oportunidades Órfãs (sem touchpoints >30 dias)
| Oportunidade | Último touchpoint | Dias sem evidência | Ação sugerida |
|-------------|-------------------|-------------------|--------------|
| OPP-2026-003 | 2026-01-15 | 45d | Revalidar ou remover |

## Candidates não linkados
Oportunidades candidatas detectadas pelo `discovery-pattern-finder` que ainda não foram adicionadas ao OST:
| Candidate | Fonte | Relevância estimada |
|-----------|-------|-------------------|
| [descrição] | pattern-finder | alta |
```

## Status de Oportunidades no OST

| Status | Significado |
|--------|------------|
| `ativa` | Oportunidade com evidências recentes, sendo trabalhada |
| `órfã` | Sem touchpoints novos há >30 dias — precisa revalidação |
| `resolvida` | Todas as soluções shipped e com resultado medido |
| `descartada` | Removida do OST por falta de relevância |

## Status de Soluções no OST

| Status | Significado |
|--------|------------|
| `ideação` | Ideia proposta, ainda não validada |
| `em-validacao` | Em Teste de Aposta (Fase 5), assumptions sendo testadas |
| `validada` | Ideia aceita e validada, pronta para concepcao ou roadmap |
| `em-concepcao` | Em concepcao (Fase 6) — PRD/one-pager sendo elaborado, trio refinando |
| `em-progresso` | Em desenvolvimento |
| `shipped` | Lançada, aguardando medição (D+30/D+90) |
| `medida` | Resultado real coletado — ciclo completo. Transição `shipped → medida` triggered pelo D+90 review com resultado real do agent `post-launch-analyzer` via `/gtm-feedback-loop` |

## Operações

### 1. Criar Árvore para Objetivo
**Trigger**: "criar OST para Objetivo 1", "montar árvore de oportunidades"

**Fluxo**:
1. Ler OKRs ativos em `reports/strategy/okrs/`
2. PM escolhe ou indica objetivo
3. Buscar oportunidades no backlog que possam estar relacionadas:
   - Ler `reports/backlog/opportunity-index.json`
   - Filtrar por módulo, tags, tipo
   - Sugerir linkagem ao PM
4. Criar arquivo `reports/strategy/ost/ost-[slug].md`
5. Atualizar `ost-index.json`

### 2. Adicionar Oportunidade à Árvore
**Trigger**: "adicionar OPP-YYYY-NNN ao OST", "linkar oportunidade ao objetivo"

**Fluxo**:
1. Ler oportunidade do backlog
2. Ler árvore do objetivo escolhido
3. Adicionar oportunidade com status `ativa`
4. Listar touchpoints existentes em `reports/discovery/` que mencionam a oportunidade
5. Atualizar contagem no `ost-index.json`
6. Atualizar `opportunity-index.json` com campo `ost_node` (opcional)

### 3. Adicionar Solução
**Trigger**: "adicionar solução à oportunidade", "nova solução no OST"

**Fluxo**:
1. PM indica oportunidade e descreve solução
2. Verificar se existe idea correspondente em `reports/strategy/ideation/`
3. Adicionar na tabela de soluções com status `ideação`
4. Se veio do `ideation-log`, referenciar IDEA-YYYY-NNN

### 4. Atualizar Status de Solução
**Trigger**: "atualizar solução SOL-001", "marcar solução como shipped"

- Atualizar status na tabela
- Se status → `shipped`: marcar data de launch
- Se status → `medida`: coletar resultado real do Pendo e registrar

### 5. Monthly Impact Review
**Trigger**: "review mensal do OST", "medir impacto das soluções"

**Fluxo**:
1. Para cada solução com status `shipped`:
   - Identificar feature/página no Pendo
   - Medir métricas relevantes (uso, frustration, NPS)
   - Comparar com baseline (antes do ship)
   - Registrar resultado real
   - Atualizar status para `medida`
2. Para cada oportunidade:
   - Verificar último touchpoint em `reports/discovery/`
   - Se >30 dias sem touchpoint, marcar como `órfã`
3. Gerar relatório de impacto

### 6. Ver Árvore
**Trigger**: "ver OST", "mostrar árvore de oportunidades"

- Se PM não especifica objetivo, mostrar resumo de todas as árvores
- Se especifica, mostrar árvore detalhada do objetivo

### 7. Linkar Touchpoint
**Trigger**: "touchpoint X é relevante para OPP-Y no OST"

- Adicionar referência do touchpoint na oportunidade
- Atualizar contagem de evidências
- Se oportunidade era `órfã`, reverter para `ativa`

## Detecção Automática

### Oportunidades Órfãs
- A cada visualização do OST, verificar datas dos últimos touchpoints
- Oportunidades sem touchpoints novos há >30 dias → marcar como `órfã`
- Sugerir: revalidar com nova discovery, ou remover do OST

### Candidates Não Linkados
- Ao visualizar OST, verificar output do `discovery-pattern-finder`
- Se há candidates novos em `reports/discovery/` não linkados a nenhuma árvore → listar como "Candidates não linkados"

## Integração com Outras Skills

| Skill/Agent | Direção | Dados |
|-------------|---------|-------|
| `okr-manager` | → OST | Objetivos são raízes das árvores |
| `discovery-touchpoint-log` | → OST | Touchpoints alimentam evidências |
| `discovery-pattern-finder` | → OST | Candidates para novas oportunidades |
| `opportunity-backlog-manager` | ↔ OST | Oportunidades são nodos do meio |
| `ideation-log` | → OST | Ideias aceitas tornam-se soluções |
| `bet-test-manager` | ↔ OST | Soluções em "em-validacao" durante bet test, "validada" após passed |
| `conception-manager` | ↔ OST | Soluções em "em-concepcao" durante concepcao (Fase 6), "em-progresso" após promoção |
| `delivery-tracker` | ← OST | Ship item atualiza solução para `shipped` |
| `gtm-feedback-loop` | ← OST | D+90 review atualiza solução para `medida` com resultado real do `post-launch-analyzer` |
| `rice-scorer` | → OST | RICE e Strategic Priority por oportunidade |
| `roadmap-planner` | ← OST | Soluções validadas alimentam roadmap |
| `strategy-dashboard` | ← OST | Seção 2 — OST Coverage |

## Observações

- OST é uma ferramenta de pensamento, não um relatório — mantenha-o vivo
- Alimentar semanalmente com discovery é essencial (hook `strategy-review-reminder.sh` cobra)
- Soluções medidas completam o ciclo: hipótese → ship → resultado → aprendizado
- Uma oportunidade pode ter múltiplas soluções — diversificar abordagens
- Órfãs não são necessariamente ruins — podem ser oportunidades de longo prazo
