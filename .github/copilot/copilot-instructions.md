# Project instructions – Flyway Database Migrations

You are helping in a database migration project built with:
- Flyway (for versioned database migrations)
- SQL scripts (DDL for schema changes, DML for data seeding, repeatable scripts)
- GitHub Actions (for automated execution of migrations in CI/CD pipelines)
- Standard Flyway folder structure: `sql/ddl/`, `sql/dml/`, `sql/repeatable/`

## General behavior

- When asked for examples, prefer SQL scripts following Flyway conventions (e.g., versioned files like `V20240131123411__create_table.sql`).
- Keep responses concise and practical, focusing on database best practices (idempotence, rollback safety, performance).
- When suggesting changes in multiple files, explain the impact on migration order, dependencies, and database state.
- Prioritize security: Avoid suggesting scripts that expose sensitive data or allow SQL injection.
- Use clear, imperative language in suggestions, and provide runnable SQL examples where possible.

## Conventional Commits

When helping write commit messages, **always follow Conventional Commits**:

- Allowed types:
  - `feat:` new feature for the user (e.g., new table or data seeding).
  - `fix:` bug fix (e.g., correcting a migration script error).
  - `refactor:` refactor that does not change database behavior (e.g., optimizing SQL).
  - `chore:` maintenance tasks (configs, tooling, etc., like updating Flyway config).
  - `docs:` documentation only (e.g., README updates).
  - `test:` add or update tests only (e.g., validation scripts).
  - `perf:` performance improvement (e.g., indexing optimizations).
  - `style:` code style changes (formatting SQL, no behavior change).
- Format:
  - Use lowercase type.
  - Optional scope between parentheses (e.g., `feat(db):` for database-related).
  - Short and clear subject in imperative form.

**Examples:**

- `feat: add customer table with indexes`
- `fix(order): handle null shipping address in data seeding`
- `refactor: optimize query in repeatable script`
- `test: add validation for migration checksums`

When the user asks you to generate a commit message:
- Summarize the main change in one short sentence.
- Use English by default for commit messages.
- Avoid generic messages like "update code" or "fix bugs".

## Code review style

When reviewing or suggesting changes:
- Prefer small, incremental migrations to avoid large, risky changes.
- First, check correctness: Ensure scripts are idempotent, handle rollbacks, and validate against target databases (e.g., PostgreSQL, MySQL).
- Then, check readability (clear comments, consistent formatting), test coverage (include dry-run validations), and performance (avoid full table scans).
- Clearly explain breaking changes, such as schema alterations that affect existing data.
- For SQL scripts: Enforce Flyway best practices (e.g., no `DROP` in versioned scripts, use placeholders for environments).

## Flyway-specific guidelines

- **File naming pattern**: Versioned migrations use `V{YYYYMMDDHHMMSS}__{description}.sql` (e.g., `V20240131123411__create_table.sql`); repeatable migrations use `R__{description}.sql` (e.g., `R__update_view.sql`).
- **Migration naming**: Use `V{YYYYMMDDHHMMSS}__{description}.sql` for versioned scripts; `R__{description}.sql` for repeatable.
- **Script structure**: Start with comments explaining purpose; end with validation queries if needed.
- **Documentation**: When creating or altering tables/columns, add database comments using `COMMENT ON TABLE table_name IS 'description';` or `COMMENT ON COLUMN table_name.column_name IS 'description';` for clarity and maintenance.
- **GitHub Actions integration**: Suggest workflows that run `flyway migrate` in staging/prod, with pre-checks for conflicts.
- **Error handling**: Always include checks for existing objects (e.g., `IF NOT EXISTS` in DDL).
- **Examples**: When generating SQL, provide complete scripts with placeholders (e.g., `${schema}` for environment-specific values).
