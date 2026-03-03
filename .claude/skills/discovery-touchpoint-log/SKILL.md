---
name: discovery-touchpoint-log
description: "Registra touchpoints de discovery no formato padronizado da Fase 2 (Continuous Discovery). Estrutura notas do PM em: comportamento observado, dores, oportunidades e evidência. Use SEMPRE que o usuário mencionar: registrar entrevista, anotei um touchpoint, conversei com cliente, fiz uma discovery, registro de entrevista, touchpoint log, registrar discovery, anotar entrevista, log de discovery, ou qualquer variação. Também acione quando o PM colar notas de entrevista ou observação de cliente."
---

# Registro Padronizado de Touchpoints de Discovery

Skill para registrar e estruturar touchpoints de discovery no formato padronizado da Fase 2 (Continuous Discovery Habits — Teresa Torres). O PM conduz as entrevistas e observações; esta skill organiza o output.

## Princípio Central

**AI augmenta, não substitui**: o PM conduz a conversa com o cliente. Esta skill recebe as notas brutas do PM e as estrutura no formato padronizado para análise posterior.

## Fontes de Dados

### Input do PM (fonte primária)
- Notas de entrevista em texto livre
- Observações de teste de protótipo
- Anotações de session replay guiado
- Notas de shadow session

### Pendo (enriquecimento)
- Verificar se o cliente mencionado tem dados no Pendo (uso, NPS, frustration)
- Complementar evidências com dados quantitativos quando relevante

## Fluxo de Execução

1. **Receber input do PM**
   - Texto livre com notas da entrevista/observação
   - Perguntar o que não estiver claro (tipo, cliente, segmento)

2. **Classificar o touchpoint**
   - **Tipo**: entrevista / teste de protótipo / session replay / shadow session
   - **Cliente**: nome da conta, contato, segmento (SMB / Mid-Market / Enterprise)
   - **Painel fixo**: sim/não (se o cliente faz parte do painel de discovery)
   - **PM responsável**: quem conduziu
   - **Data**: quando aconteceu

3. **Estruturar no formato padronizado**
   - **Comportamento observado**: o que o usuário FEZ (não o que disse que faz)
     - Ações concretas, fluxos percorridos, decisões tomadas
     - Workarounds utilizados
   - **Dores identificadas**: frustrações, bloqueios, gaps
     - Separar dores explícitas (usuário verbalizou) de implícitas (observadas)
   - **Oportunidades**: conexão com OST existente ou nova oportunidade
     - Verificar se há opportunity tree em `reports/` ou GitHub Issues relacionadas
   - **Evidência**: citações diretas, timestamps de replay, observações factuais
     - Manter linguagem original do cliente nas citações

4. **Validar qualidade**
   - Verificar que todos os 4 campos obrigatórios estão preenchidos
   - Alertar se "comportamento observado" contém opinião em vez de ação
   - Sugerir ajustes se evidências são genéricas demais

5. **Salvar e registrar**
   - Salvar em `reports/discovery/touchpoint-YYYY-MM-DD-[cliente-slug].md`
   - Registrar como touchpoint da semana para tracking de cadência

## Formato de Saída

```
# Touchpoint de Discovery
**Data**: [YYYY-MM-DD]
**PM**: [nome]
**Tipo**: [entrevista | teste de protótipo | session replay | shadow session]

## Cliente
**Conta**: [nome da conta]
**Contato**: [nome do contato, cargo]
**Segmento**: [SMB | Mid-Market | Enterprise]
**Painel fixo**: [Sim | Não]

## Comportamento Observado
_O que o usuário fez (não o que disse que faz)_

- [comportamento 1 — ação concreta observada]
- [comportamento 2 — fluxo percorrido]
- [workaround utilizado, se houver]

## Dores Identificadas
_Frustrações, bloqueios, gaps_

- **[dor 1]**: [descrição] _(explícita / implícita)_
- **[dor 2]**: [descrição] _(explícita / implícita)_

## Oportunidades
_Conexão com estratégia existente ou nova oportunidade_

- [oportunidade 1 — conexão com OST ou nova]
- [oportunidade 2]

## Evidência
_Citações diretas, timestamps, observações factuais_

> "[citação direta do cliente]"

> "[outra citação]"

- Timestamp replay: [se aplicável]
- Observação: [fato observado, não interpretação]

---
_Registrado via Product OS — Discovery Touchpoint Log_
_Touchpoint [N] da semana [N/YYYY]_
```

## Exemplo

**Input**: "Fiz uma entrevista com o João da Acme Corp hoje. Ele é Mid-Market. Vi que ele fica fazendo copy-paste de dados do pipeline pra uma planilha Excel porque não consegue gerar o relatório que o gestor pede. Falou 'eu perco 1 hora por dia nessa gambiarra'. Ele nem sabia que existia o módulo de relatórios customizados."

**Output**: Touchpoint estruturado com:
- Comportamento: "Copy-paste manual de dados do pipeline para Excel para gerar relatório gerencial"
- Dor: "Processo manual de 1h/dia para reportar ao gestor (workaround)" (explícita)
- Dor: "Desconhecimento do módulo de relatórios customizados" (implícita)
- Oportunidade: "Melhorar discoverability de relatórios customizados; investigar se template padrão de relatório gerencial resolveria"
- Evidência: Citação direta "eu perco 1 hora por dia nessa gambiarra"

## Observações

- NUNCA editar ou "melhorar" citações do cliente — manter a linguagem original
- Comportamento observado deve ser factual: "usuário clicou em X, voltou para Y, abriu planilha" — não "usuário ficou confuso" (isso é interpretação)
- Se o PM reportar apenas opiniões do cliente ("ele disse que quer X"), gentilmente perguntar: "o que ele fez que te levou a essa conclusão?" para extrair o comportamento
- Dores implícitas são tão valiosas quanto explícitas — o PM observou algo que o cliente nem percebe como problema
- Sempre verificar se a oportunidade conecta com algo já mapeado (OST, GitHub Issues, roadmap)
