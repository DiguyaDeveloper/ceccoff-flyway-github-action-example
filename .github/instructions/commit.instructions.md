# Instruções Globais para Geração de Mensagens de Commit

Sempre que o usuário solicitar ajuda para escrever uma mensagem de commit, ou quando você identificar que ele está criando um commit, siga as regras abaixo.

---

# 🧠 1. Sempre usar Conventional Commits

A estrutura obrigatória é:

**`<tipo>(escopo opcional): <descrição curta e imperativa>`**

Exemplos:

- `feat: adicionar endpoint de criação de usuários`
- `fix: corrigir cálculo de juros`
- `refactor(core): simplificar lógica de validação`
- `docs(readme): atualizar seção de instalação`
- `test: adicionar testes unitários para serviço X`
- `chore: atualizar dependências`

---

# 🏷️ 2. Tipos aceitos

Use apenas os tipos oficiais:

- feat
- fix
- refactor
- perf
- docs
- style
- test
- build
- chore
- revert
- ci

---

# ✍️ 3. Regras para a descrição

A descrição deve:

- ser escrita em português brasileiro  
- ser curta e objetiva  
- começar com verbo no imperativo

Exemplos válidos:

- `fix: corrigir validação de CPF`
- `refactor(core): reorganizar módulo de autenticação`

---

# 📝 4. Corpo opcional do commit

Quando necessário, incluir:

contexto, motivo, solução e impactos

Formato sugerido:

```
contexto: ...
motivo: ...
solução: ...
impactos: ...
```

---

# 🔁 5. BREAKING CHANGE

Quando a mudança quebrar compatibilidade:

```
BREAKING CHANGE: descrição do impacto e instruções de migração
```

---

# 🧪 6. Basear commits no diff real

- Nunca invente mudanças  
- Não inclua arquivos não alterados  
- Não gere commits genéricos  

---

# 🚫 7. Proibições

- Nada de “ajustes”, “update”, “fix stuff”  
- Não misture assuntos diferentes  

---

# 📌 8. Idioma

Sempre escrever em **português brasileiro**, a menos que solicitado.

---

# ✨ 9. Quando o usuário pedir “gere mensagem de commit”

Você deve:

1. Ler o diff  
2. Determinar o tipo correto  
3. Gerar commit claro, conciso e profissional  
4. Seguir todas as regras acima  

---

# 🔒 10. Estilo geral

- Objetivo  
- Técnico  
- Sem ruído  
