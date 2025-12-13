# Database Migration Project with Flyway and GitHub Actions 🗄️

> Gerenciamento de migrações de banco de dados usando Flyway, com execuções automáticas e manuais via GitHub Actions

## 📁 Estrutura do Projeto

```txt
.
├── .github/
│   ├── chatmodes/
│   │   └── GPT-Beast.agent.md
│   │
│   ├── copilot/
│   │   └── instructions/
│   │       ├── sql.instructions.md
│   │       ├── copilot-instructions.md
│   │       ├── commit.instructions.md
│   │       └── pull_request.instructions.md
│   │
│   ├── pull_request_template.md
│   │
│   ├── scripts/
│   │   └── notify.js
│   │
│   └── workflows/
│       ├── flyway-migrate.yml
│       └── sql-validate-pr.yml
│
├── .vscode/
│   └── (configurações do VS Code)
│
├── docker/
│   └── (arquivos de infraestrutura Docker)
│
├── docs/
│   └── (documentações adicionais)
│
├── scripts/
│   └── (scripts utilitários ou operacionais)
│
├── sql/
│   ├── ddl/
│   ├── dml/
│   └── repeatable/
│   └── (scripts SQL e migrações)
|
├── .flyway-version
├── .sqlfluff
├── flyway.conf
│
└── README.md
```

## 📝 Scripts SQL

### Scripts Versionados (V__)

- **Formato:** `V{YYYYMMDDHHMMSS}__{descricao}.sql`
- **Uso:** Alterações de estrutura (DDL) e dados (DML)
- **Execução:** Uma única vez, em ordem cronológica

### Scripts Repetíveis (R__)

- **Formato:** `R__{descricao}.sql`
- **Uso:** Views, procedures e funções
- **Execução:** Sempre que modificados, após scripts versionados

## 🔄 Execução

- **PRs:** Validação automática de SQL em PRs que tocam `sql/**`.
- **Migrações:** Disparo manual via GitHub Actions (`workflow_dispatch`).

## 🌍 Ambientes

| Ambiente | Descrição                |
| -------- | ------------------------ |
| dev      | Desenvolvimento (padrão) |
| hml      | Homologação              |
| prod     | Produção                 |

## ✅ Boas Práticas

- Scripts versionados são imutáveis após commit
- Use `CREATE OR REPLACE` em scripts repetíveis
- Mantenha scripts idempotentes
- Documente alterações complexas

## 🚀 Como rodar localmente

- Suba o Postgres de teste: `docker-compose -f docker/docker-compose.yml up -d`
- Rode o workflow local com aprovação simulada via `act` (veja o passo a passo detalhado em `docs/LOCAL_TESTING.md`).
- Para desmontar: `docker-compose -f docker/docker-compose.yml down -v`

## 🔧 Workflows CI/CD

| Arquivo | Nome no GitHub | Trigger | Propósito | Observações |
| --- | --- | --- | --- | --- |
| `sql-validate-pr.yml` | 🔍 SQL Validate PR (sql/**) | `pull_request` (base `main`, path `sql/**`) | Lint/nomenclatura/comentário inicial + sqlfluff | Usa Python/sqlfluff; fetch-depth 0 |
| `flyway-migrate.yml` | 🗄️ Flyway Migration (manual/local) | `workflow_dispatch` | Unifica local (via inputs) e ambientes (via secrets) | Valida sempre; migra em dois ramos: `local` (usa inputs e `approved=true` para act), ambientes dev/hml/prod (aprovam via Environments) |

### 🔑 Secrets/vars necessários para `flyway-migrate.yml`

- Para `environment` ≠ `local`: `DB_URL`, `DB_USER`, `DB_PASS` (secrets por ambiente no GitHub Environments).
- Para `environment=local`: fornecer `db_url`, `db_user`, `db_pass` via inputs no dispatch.
- (Opcional) `GITHUB_TOKEN` com permissão para comentar/notificar via `.github/scripts/notify.js`.

