---
applyTo: "sql/ddl/**, sql/dml/**, sql/repeatable/**"
---

# SQL Migration Instructions – Flyway

You are writing SQL scripts for database migrations using Flyway.

## Language and style

- Use standard SQL syntax compatible with your target database (e.g., PostgreSQL, MySQL, SQL Server).
- Follow clean, readable SQL:
  - Prefer small, focused scripts (one change per migration).
  - Use uppercase for keywords (SELECT, INSERT, etc.) and lowercase for identifiers.
  - Add comments at the top of each script explaining the purpose and impact.
- Name tables, columns, and constraints clearly and meaningfully in English.
- Avoid hardcoded values; use placeholders if needed (e.g., ${schema} for environment-specific schemas).

## Migration structure

Follow Flyway's **versioned and repeatable migration patterns**:

- **Versioned migrations** (`V{YYYYMMDDHHMMSS}__{description}.sql`):
  - For schema changes (DDL) or initial data seeding (DML).
  - Must be idempotent: Use `IF NOT EXISTS` for CREATE statements, check for existing data before INSERT.
  - Avoid destructive operations like `DROP` in production-ready scripts.

- **Repeatable migrations** (`R__{description}.sql`):
  - For views, functions, or triggers that need updates.
  - Flyway re-runs them if checksum changes.

- **Baseline migrations** (if needed):
  - For existing databases without prior migrations.

When generating examples, use file structures similar to:

- `sql/ddl/V20240131123411__create_user_table.sql`
- `sql/dml/V20240131123412__seed_initial_data.sql`
- `sql/repeatable/R__update_user_view.sql`

## Flyway usage

- Ensure scripts are executable in any order (versioned migrations run sequentially).
- Use transactions implicitly (Flyway wraps each script in a transaction by default).
- For multi-statement scripts, separate with semicolons and test for syntax errors.
- Prefer explicit column lists in INSERT/UPDATE to avoid issues with schema changes.

Example versioned script:

```sql
-- Create user table with indexes
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_users_email ON users (email);
