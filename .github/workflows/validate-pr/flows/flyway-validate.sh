#!/bin/bash
set -e

FLYWAY_VERSION=$1

echo "🔍 Flyway Validate"

DB_HOST=$(echo "${FLYWAY_URL}" | sed -E 's|jdbc:postgresql://([^/:]+)(:[0-9]+)?/([^?]+).*|\1|')
DB_NAME=$(echo "${FLYWAY_URL}" | sed -E 's|jdbc:postgresql://[^/]+/([^?]+).*|\1|')

EXISTS=$(docker run --rm --network host -e PGPASSWORD="${FLYWAY_PASSWORD}" postgres:16 \
  psql -h "${DB_HOST}" -U "${FLYWAY_USER}" -d "${DB_NAME}" -tAc "SELECT 1 FROM information_schema.tables WHERE table_schema='scheduler' AND table_name='flyway_schema_history';" || true)

if [ "${EXISTS}" != "1" ]; then
  echo "⚠️ flyway_schema_history não encontrada — pulando 'flyway validate' (banco novo)."
else
  docker run --rm --network host \
    -v "${GITHUB_WORKSPACE}:/workspace" \
    -w /workspace \
    -e FLYWAY_URL -e FLYWAY_USER -e FLYWAY_PASSWORD \
    flyway/flyway:${FLYWAY_VERSION} \
    validate
fi

echo "✅ Flyway validate executado"
