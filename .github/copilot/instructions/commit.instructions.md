---
applyTo: "**"
---

# Global Instructions for Auto-Generating Conventional Commit Messages
# (Prompts in English — Output in Brazilian Portuguese)

These instructions apply globally to the workspace.  
Whenever the user requests a commit message, or when generating commit messages as part of a workflow, follow the rules below.

---

## 1. Purpose
Your goal is to create high-quality commit messages that follow the Conventional Commits specification, written entirely in Brazilian Portuguese, concise, clear, and based strictly on the actual diff.

Prompts are written in English to optimize reasoning, but output must always be Portuguese unless explicitly requested otherwise.

---

## 2. Commit Format (required)

<type>(optional-scope): <short imperative description in Portuguese>

(optional body explaining context, motivation, solution, impacts)

(optional footer for BREAKING CHANGES or issue references)

Allowed types:
feat, fix, refactor, docs, style, test, perf, build, ci, chore, revert

---

## 3. Choosing the Correct Type

feat → new feature or behavior  
fix → correcting incorrect behavior  
refactor → internal structural changes without behavior changes  
docs → documentation updates  
test → new or modified tests  
style → formatting only  
perf → performance improvements  
build/ci → pipeline or build configs  
chore → maintenance tasks  
revert → revert previous commit  

---

## 4. Commit Description Rules

Description must be:

- in Brazilian Portuguese  
- short and objective  
- in imperative form  
- max ~70 characters when possible  
- derived strictly from the diff  

Examples:
fix: corrigir validação de CPF  
feat: adicionar cálculo de tarifa  
refactor(core): reorganizar lógica de autenticação  

---

## 5. Commit Body (optional)

Use only when needed.

contexto: ...  
motivo: ...  
solução: ...  
impactos: ...

Must be concise and technical.

---

## 6. BREAKING CHANGES

If the change breaks compatibility:

BREAKING CHANGE: descrição do impacto e instruções de migração

And reflect breaking change in the title:
feat!: alterar contrato de autenticação

---

## 7. Diff-Based Generation

- Inspect diff before generating  
- Do not invent changes  
- Do not include untouched files  
- Accuracy over verbosity  

---

## 8. Forbidden Behavior

- Do not write commits in English (unless requested)  
- Do not use vague descriptions like "ajustes" or "update"  
- Do not mix unrelated changes  
- Do not create overly long messages  

---

## 9. When user says “generate commit message”

Steps:

1. Review diff  
2. Determine correct type  
3. Generate professional commit message in Portuguese  
4. Follow Conventional Commits strictly  

Output example:

feat(api): adicionar suporte para atualização de perfis

contexto: a API não permitia atualizar dados parciais de perfil  
solução: adicionar novo endpoint PATCH /perfil/{id}  
impactos: exige atualização no cliente mobile  

---

## 10. Language Rules

- Instructions/prompts: English  
- Output: Brazilian Portuguese  

---

## 11. Git Workflow Integration

If user wants full command:

git commit -m "<title>" -m "<body>"

But do NOT run commands unless explicitly requested.

---

## 12. Style

Professional  
Succinct  
Technical  
Accurate  
Best practices aligned  
