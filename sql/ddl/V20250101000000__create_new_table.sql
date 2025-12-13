-- V20250101000000__create_new_table.sql
-- Cria a tabela `new_table_example` como estrutura inicial de exemplo.
-- Mantém idempotência com IF NOT EXISTS para evitar erro em reaplicações.

CREATE TABLE IF NOT EXISTS new_table_example (
    id SERIAL PRIMARY KEY
);
