#!/bin/bash
set -e

echo "🔍 Verificando Estrutura dos Arquivos SQL"

if [ ! -d "sql" ]; then
  echo "::error::Diretório sql/ não encontrado"
  exit 1
fi

for dir in ddl dml repeatable; do
  if [ ! -d "sql/$dir" ]; then
    echo "::warning::Diretório sql/$dir não encontrado"
  fi
done

echo "✅ Estrutura verificada"
