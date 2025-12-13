#!/bin/bash
set -e

echo "💡 Garantindo que o schema 'scheduler' existe"

DB_HOST=$(echo "${FLYWAY_URL}" | sed -E 's|jdbc:postgresql://([^/:]+)(:[0-9]+)?/([^?]+).*|\1|')
DB_NAME=$(echo "${FLYWAY_URL}" | sed -E 's|jdbc:postgresql://[^/]+/([^?]+).*|\1|')

docker run --rm --network host -e PGPASSWORD="${FLYWAY_PASSWORD}" postgres:16 \
  psql -h "${DB_HOST}" -U "${FLYWAY_USER}" -d "${DB_NAME}" -c "CREATE SCHEMA IF NOT EXISTS scheduler;"

echo "✅ Schema 'scheduler' garantido"
