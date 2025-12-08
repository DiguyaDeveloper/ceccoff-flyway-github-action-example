-- V20250101000000__create_new_table.sql
-- Cria a tabela `new_table_example` caso ainda não exista.
-- Esta migration adiciona a tabela de exemplo para futuras operações e testes.
-- Garante que a estrutura básica esteja disponível antes de outras migrations que dependam desta tabela.

CREATE TABLE IF NOT EXISTS new_table_example (
    id SERIAL PRIMARY KEY
);
