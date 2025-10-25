# Database Migration Project 🗄️

> Gerenciamento de migrações de banco de dados usando Flyway

## 📁 Estrutura do Projeto

```doc
├── sql/
│   ├── ddl/         # Estrutura (CREATE, ALTER TABLE)
│   ├── dml/         # Dados (INSERT, UPDATE, DELETE)
│   └── repeatable/  # Views e Procedures
└── .github/workflows/
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

- **Automática:** Push na branch main
- **Manual:** Via GitHub Actions

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
# ceccoff-flyway-github-action-example
