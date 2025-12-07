-- V20230101000000__create_schema_scheduler.sql
-- Cria o schema `scheduler` caso ainda não exista.
-- Esta migration foi adicionada para garantir que o schema alvo exista
-- antes das demais migrations aplicarem objetos.

CREATE SCHEMA IF NOT EXISTS scheduler;
