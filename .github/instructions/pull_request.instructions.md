# Instruções Globais para Auto-Preenchimento de Pull Requests

Estas instruções se aplicam ao workspace inteiro.  
Sempre que o usuário solicitar ações como:

- “gerar PR”
- “preencher PR”
- “criar pull request automático”
- “gerar changelog”
- “organizar alterações”
- “gerar título para o PR”

você deve executar o fluxo abaixo.

---

# 🧠 1. Análise do Contexto

Leia automaticamente:

- o **diff do branch atual** em relação à base (ex.: `main`)
- o **nome da branch** (usado para inferir tipo do PR)
- os **commits** deste branch (especialmente Conventional Commits)
- os **arquivos alterados**

Derive exclusivamente desses elementos — nunca invente conteúdo.

---

# 🎯 2. Identificação Automática do Tipo de PR

Determine o tipo do PR seguindo estas regras:

### ✔️ Feature PR
- Branch contém: `feature/`, `feat/`
- Commits predominantes: `feat:`
- Presença de funcionalidades novas

### ✔️ Bugfix PR
- Branch contém: `fix/`, `bugfix/`
- Commits predominantes: `fix:`
- Correções localizadas no fluxo

### ✔️ Refactor PR
- Branch contém: `refactor/`
- Commits predominantes: `refactor:`
- Nenhuma mudança funcional, apenas estrutura

### ✔️ Release PR
- Branch contém: `release/x.y.z`, `vX.Y.Z`
- Conjunto grande de commits mistos
- Mudanças amplas que consolidam versões

---

# 📝 3. Gerar Título do PR (sempre em Português)

Gerar sempre um título conforme **Conventional Commits**:

**`<tipo>: <descrição curta, clara e imperativa>`**

Exemplos:

- `feat: adicionar endpoint de criação de cliente`
- `fix: corrigir cálculo de juros em operações de crédito`
- `refactor: reorganizar serviços de validação`
- `chore(release): versão 1.4.2`

A descrição deve ser derivada do diff e dos commits.

---

# 📦 4. Preencher Categorias (feat / refactor / fix)

Preencha os blocos do template assim:

### ✨ feat
Liste **somente** funcionalidades novas detectadas no diff.

### ♻️ refactor
Liste reorganizações, renomeações e melhorias internas.

### 🐞 fix
Liste correções de comportamento ou erros funcionais.

Se alguma categoria não se aplicar, deixe-a vazia — mas não remova.

---

# 🔍 5. Gerar Changelog Profissional (IA)

Criar um resumo em português, seguindo boas práticas observadas em templates corporativos:

> “Este PR adiciona X, corrige Y e refatora Z, impactando os módulos A, B e C.  
> A mudança melhora o fluxo de N e reduz riscos de regressão no componente M.”

Para Release PR:

> “Esta release agrega X funcionalidades, corrige Y problemas reportados e aplica Z refatorações estruturais.  
> Inclui ajustes de performance, melhorias de arquitetura e estabilização de módulos críticos.”

O changelog deve ser **factual, objetivo e baseado no diff real**.

---

# 🧪 6. Testes

Detecte automaticamente:

- arquivos de teste alterados
- novos testes criados
- cenários impactados

Preencha a seção de testes com:

- como a mudança foi validada
- riscos remanescentes
- cenários recomendados para validação manual
- impactos nos pipelines

Nunca invente testes inexistentes.

---

# 🛡️ 7. Impactos e Riscos

Analise e preencha com base no diff:

- possíveis regressões
- módulos sensíveis afetados
- mudanças de contratos (APIs, DTOs, eventos)
- riscos de segurança
- impacto em performance
- dependências ou integrações envolvidas

Dê ao revisor uma visão clara **do que deve ser observado com atenção**.

---

# 🧱 8. Mudanças Técnicas e Arquiteturais

Relate:

- camadas afetadas (API, domínio, infra, UI)
- novos serviços, entidades, handlers, mappers
- padrões aplicados (DDD, Clean Architecture, Ports & Adapters)
- decisões técnicas observadas no diff

A explicação deve ser curta, porém rica em contexto.

---

# ✔️ 9. Checklist Automático

Com base no diff e commits:

- marque se Conventional Commits foram seguidos
- marque se testes foram criados ou alterados
- sinalize necessidade de documentação
- sinalize breaking changes se detectadas

Não marque nada sem evidência real.

---

# 🧭 10. Gerar a Saída no Formato do Template

Ao final, gere **exatamente no formato do arquivo `pull_request_template.md`**, preenchendo:

- Descrição Geral  
- Categorias  
- Changelog  
- Testes  
- Impactos / Riscos  
- Mudanças Técnicas  
- Checklists  
- Como Testar (somente se aplicável)

Sempre escreva em **português brasileiro**.

---

# 🔒 Regras Importantes

- Não invente mudanças — derive tudo do diff.
- Não invente testes — derive de arquivos reais.
- Não altere a estrutura do template.
- Não altere tom, idioma ou ordem das seções.
- Seja profissional, claro e objetivo.
- Preencha tudo automaticamente quando solicitado:
  - “Gerar PR”
  - “Montar PR”
  - “Preencher PR”
  - “Criar PR completo”
