#!/usr/bin/env bash
set -euo pipefail

# Script de conveniência para testes locais:
# - Limpa o ambiente Docker
# - Sobe o docker-compose de teste
# - Aguarda o Postgres aceitar conexões
# - Configura pg_hba.conf
# - Executa o workflow local via act

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "1) Limpando ambiente Docker..."
docker stop $(docker ps -aq) 2>/dev/null || true
docker rm $(docker ps -aq) 2>/dev/null || true
docker volume rm docker_pgdata 2>/dev/null || true

echo "2) Subindo Postgres de teste via docker-compose..."
cd docker
docker-compose up -d
cd ..

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

echo "3) Configurando pg_hba.conf para trust..."
docker exec -i local-postgres bash -c "echo 'host all all 0.0.0.0/0 trust' >> /var/lib/postgresql/data/pg_hba.conf"
docker exec -i local-postgres psql -U app -d appdb -c "SELECT pg_reload_conf();"

echo "4) Executando validação com act..."
act -j validate --input environment=local \
  --secret DB_URL=jdbc:postgresql://localhost:5432/appdb \
  --secret DB_USER=app \
  --secret DB_PASS=app

echo "5) Executando migração com act..."
act -j migrate_local --input environment=local --input approved=true --input command=migrate \
  --secret DB_URL=jdbc:postgresql://localhost:5432/appdb \
  --secret DB_USER=app \
  --secret DB_PASS=app

echo "6) Verificação rápida no banco (tabelas em 'scheduler')"
docker exec -i local-postgres psql -U app -d appdb -c "\dt scheduler.*"

echo "Concluído. Se quiser desmontar o Postgres de teste: cd docker && docker-compose down -v"
