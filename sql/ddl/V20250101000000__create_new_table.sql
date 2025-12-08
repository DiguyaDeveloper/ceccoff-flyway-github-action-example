-- V20250101000000__create_new_table.sql
-- Cria a tabela `new_table_example` caso ainda não exista.
-- Esta migration adiciona a tabela de exemplo para futuras operações e testes.
-- Garante que a estrutura básica esteja disponível antes de outras migrations que dependam desta tabela.

-- NOTE: The table `new_table_example` is intentionally created with only an `id` column
-- as a placeholder for future development. Additional columns will be added in subsequent
-- migrations as requirements are defined.
CREATE TABLE IF NOT EXISTS new_table_example (
    id SERIAL PRIMARY KEY
);

COMMENT ON TABLE new_table_example IS
'Tabela de exemplo criada como estrutura base para futuras operações e testes. '
'Contém apenas a coluna id como placeholder, com colunas adicionais a serem '
'definidas em migrations subsequentes.';
