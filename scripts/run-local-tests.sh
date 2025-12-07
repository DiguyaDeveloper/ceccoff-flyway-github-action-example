#!/usr/bin/env bash
set -euo pipefail

# Script de conveniência para testes locais:
# - Sobe o docker-compose de teste
# - Aguarda o Postgres aceitar conexões
# - Executa o workflow local via act em modo simulado (approved=true)

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "1) Subindo Postgres de teste via docker-compose..."
docker-compose -f docker/docker-compose.yml up -d

echo "Aguardando DB ficar disponível (até 60s)..."
for i in $(seq 1 60); do
  if docker exec -i local-postgres pg_isready -U app >/dev/null 2>&1; then
    echo "Postgres está pronto"
    break
  fi
  sleep 1
done

if ! docker exec -i local-postgres pg_isready -U app >/dev/null 2>&1; then
  echo "Postgres não ficou pronto em 60s" >&2
  exit 1
fi

echo "2) Executando workflow local com act (simulando aprovação)..."
echo "Comando: act -W .github/workflows/db-migrate-local.yml -j migrate_local --input environment=dev --input command=migrate --input approved=true"

act -W .github/workflows/db-migrate-local.yml -j migrate_local \
  --input environment=dev \
  --input command=migrate \
  --input approved=true

echo "3) Verificação rápida no banco (tabelas em 'scheduler')"
docker exec -i local-postgres psql -U app -d appdb -c "\dt scheduler.*"

  echo "Concluído. Se quiser desmontar o Postgres de teste: docker-compose -f docker/docker-compose.yml down -v"
