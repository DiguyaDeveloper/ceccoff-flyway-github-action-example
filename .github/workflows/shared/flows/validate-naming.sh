#!/bin/bash
set -e

echo "::group::Validação de Nomenclatura"

error_count=0
error_files=""

# Validar DDL
for file in sql/ddl/*.sql; do
  if [[ -f "$file" ]]; then
    basename=$(basename "$file")
    echo "🔎 Verificando: $file"
    if [[ ! $basename =~ ^V[0-9]{14}__ ]]; then
      echo "::error file=$file::❌ $basename - Não segue o padrão VYYYYMMDDHHMMSS__"
      error_count=$((error_count + 1))
      error_files="$error_files\n- $file"
    else
      echo "✅ $basename - OK"
    fi
  fi
done

# Validar Repeatable
for file in sql/repeatable/*.sql; do
  if [[ -f "$file" ]]; then
    basename=$(basename "$file")
    echo "🔎 Verificando: $file"
    if [[ ! $basename =~ ^R__ ]]; then
      echo "::error file=$file::❌ $basename - Não segue o padrão R__"
      error_count=$((error_count + 1))
      error_files="$error_files\n- $file"
    else
      echo "✅ $basename - OK"
    fi
  fi
done

if [ $error_count -gt 0 ]; then
  echo "❌ Encontrados $error_count arquivo(s) com erro de nomenclatura:" >&2
  echo -e "$error_files" >&2
  exit 1
fi

echo "✅ Todos os arquivos seguem o padrão de nomenclatura"
echo "::endgroup::"
