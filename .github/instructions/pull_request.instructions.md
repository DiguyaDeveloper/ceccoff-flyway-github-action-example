---
description: 'Professional PR auto-fill instructions for GitHub Copilot, aligned with Conventional Commits and a structured PR template. Prompts in English, PR content in Brazilian Portuguese.'
tags: ['pr', 'pull-request', 'review', 'conventional-commits', 'standardization']
appliesTo: ['**/*']
---

# Global Instructions for Auto-Filling Pull Requests

These instructions are inspired by patterns used in professional Copilot customization repos and large enterprise projects.  
They are meant to work together with a Markdown PR template (e.g. `.github/pull_request_template.md`).

All guidance below uses **English phrasing for the model**, but **all generated PR content must be in Brazilian Portuguese** unless explicitly requested otherwise.

---

## 1. When to Apply These Instructions

Apply this workflow whenever the user:

- creates or edits a Pull Request description
- asks to “generate PR”, “fill PR”, “auto-fill PR”, “montar PR”, or similar
- asks you to summarize the current changes for review

---

## 2. Inputs You Must Analyze

Before generating or updating a PR description, always:

1. Read the **Git diff** between the source branch and the target branch.
2. Inspect the **commit history** on the source branch (prefer Conventional Commits semantics).
3. Detect:
   - files changed (back-end, front-end, tests, configs, docs)
   - whether new features, fixes, refactors, or releases are involved
4. Optionally infer:
   - domain impact (e.g., billing, authentication, reporting)
   - architectural layers (API, domain, infrastructure, UI)

Never invent changes that do not appear in the diff or commits.

---

## 3. Language Requirements

- All PR content you generate (titles, descriptions, changelog, checklists, etc.) must be in **Brazilian Portuguese**.
- Keep the tone **professional, concise, and objective**, similar to an experienced engineer writing for code review.
- Use clear technical vocabulary when describing behavior, impact, and risks.

---

## 4. PR Title Rules (Conventional Commit Style)

Generate a PR title following **Conventional Commits semantics**, in Brazilian Portuguese:

`<type>: <descrição curta e imperativa>`

Allowed types (non-exhaustive):

- `feat` – nova funcionalidade
- `fix` – correção de bug
- `refactor` – mudança interna sem alterar comportamento observável
- `docs` – mudanças de documentação
- `perf` – melhorias de performance
- `test` – criação/alteração de testes
- `chore` – manutenção, scripts, tarefas de rotina
- `ci` / `build` – pipelines, build, configuração de deploy
- `revert` – reversão de commit anterior

Examples (good):

- `feat: adicionar fluxo de reemissão de boleto`
- `fix: corrigir cálculo de juros em operações de crédito`
- `refactor: reorganizar serviços de validação de clientes`

The title must be derived from the actual changes, not invented.

---

## 5. Understanding the PR Type

Based on diff + commits, categorize the PR:

- **Feature PR**  
  New endpoints, UI flows, domain use cases, or business rules.

- **Bugfix PR**  
  Corrects erroneous behavior, broken flows, or defects reported.

- **Refactor PR**  
  Restructuring code, improving readability, splitting responsibilities, but keeping behavior equivalent.

- **Release PR**  
  Aggregates multiple changes into a version bump, often touching change logs, manifests, or CI.

This classification should be reflected in:

- title choice (`feat`, `fix`, `refactor`, etc.)
- changelog emphasis
- risk and impact explanation

---

## 6. Mapping to the PR Template Sections

Assume a template with sections similar to:

- Descrição Geral  
- Alterações por Categoria (`feat`, `refactor`, `fix`)  
- Changelog (gerado por IA)  
- Testes  
- Impactos / Riscos  
- Mudanças Técnicas  
- Checklists  
- Como Testar  

Your job is to **auto-fill** these sections using the diff and commit history.

### 6.1. Descrição Geral

- Explain **what** was changed and **why**.
- Use 2–5 sentences, objective and contextual.
- Mention business or functional context (e.g., “fluxo de antecipação”, “módulo de faturamento”).

Example:

> Este PR adiciona o fluxo de reemissão de boletos para clientes inadimplentes e corrige validações de data de vencimento.  
> Também reorganiza partes do serviço de cobrança para facilitar a inclusão de novos meios de pagamento.

### 6.2. Alterações por Categoria (feat / refactor / fix)

Populate:

- `feat` → list new behaviors / endpoints / UI features
- `refactor` → list internal reorganizations, renomeações, extração de componentes/serviços
- `fix` → list corrections of wrong or unexpected behavior

Each item should be a short bullet in Portuguese, describing the impact.

Example:

- **feat**
  - adicionar endpoint `POST /v1/billing/invoices/{id}/reissue`
- **refactor**
  - extrair lógica de cálculo de juros para `InterestCalculationService`
- **fix**
  - corrigir cálculo de multa quando a data de pagamento é igual à data de vencimento

If a category does not apply, leave it empty but do not remove the section.

### 6.3. Changelog (gerado por IA)

Generate a **short, structured changelog** in Portuguese, focusing on:

- high-level summary
- main functional impacts
- systems/modules impacted

For feature/fix PRs:

> Este PR adiciona X, corrige Y e refatora Z, impactando os módulos A, B e C.  
> Melhora o fluxo de N e reduz o risco de regressões em M.

For release PRs:

> Esta release consolida X novas funcionalidades, Y correções e Z refatorações estruturais, incluindo melhorias em performance, observabilidade e estabilidade dos módulos críticos.

### 6.4. Testes

Based on the diff:

- Identify new or modified test files.
- Infer types of tests:

  - unit tests
  - integration tests
  - end-to-end or contract tests

Fill in:

- como a mudança foi validada
- cenários principais cobertos
- principais casos de borda testados (quando houver)

Never invent tests that do not exist in the codebase.

### 6.5. Impactos / Riscos

Always consider:

- potencial para regressão em áreas sensíveis
- mudanças em contratos (APIs, eventos, DTOs)
- alterações em performance (queries, loops pesados, IO)
- efeitos em integrações externas (bancos, serviços terceiros, filas)

Example bullets:

- pode impactar o fluxo de emissão de boletos existentes
- altera a forma de cálculo de juros em operações de crédito
- aumenta carga em consultas ao banco na tabela X

### 6.6. Mudanças Técnicas

Explain technical/architectural parts for reviewers:

- camadas afetadas (API, domínio, infraestrutura, UI)
- novos serviços, entidades, handlers, adapters
- padrões aplicados (DDD, Clean Architecture, Ports & Adapters)
- decisões relevantes (ex.: nova estratégia de cache, fallback, retry)

Example:

> Introduzimos o `InvoiceReissueUseCase` na camada de domínio, com um novo repositório `InvoiceRepository` e um adapter REST para exposição via controller Spring.  
> Também foram extraídos validadores específicos de datas para uma classe dedicada.

### 6.7. Checklists

If there is a checklist in the template, fill or suggest items such as:

- [ ] Commits seguem **Conventional Commits**  
- [ ] Testes automatizados relevantes foram adicionados/atualizados  
- [ ] Documentação de API ou README foi ajustada (quando necessário)  
- [ ] Não há TODOs deixados para trás em código de produção  

Mark items as checked only when there is evidence in the diff/commits.

---

## 7. Rules for Accuracy and Scope

- Do **not** invent features, tests, or risks that are not supported by the diff.
- Do **not** change the structure of the PR template.
- Use concise, clear phrases; avoid repetition.
- Prefer bullet points over long paragraphs.
- Always think like a senior engineer preparing a PR for another senior engineer.

---

## 8. Interaction Examples

When the user says, for example:

- “gera a descrição do PR”
- “monta o PR para mim”
- “preencher template de PR”
- “gerar changelog deste PR”

You should:

1. Analyze the diff and commits.
2. Classify the PR (feat, fix, refactor, release, etc.).
3. Generate:
   - title (Conventional Commit, in PT-BR)
   - filled sections for Descrição, Categorias, Changelog, Testes, Impactos, Mudanças Técnicas, Checklists
4. Output everything in Markdown already aligned to the structure of the existing `pull_request_template.md`.

---

## 9. Final Style

- Professional, calm, and objective tone.
- No marketing language.
- No unnecessary emojis in the generated PR body (keep it clean), unless the template explicitly uses them.
- Prefer short, information-dense sentences.

The result should feel like a well-written PR by a senior engineer in a Brazilian enterprise backend project.
