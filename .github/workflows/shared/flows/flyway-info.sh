#!/bin/bash
set -e

FLYWAY_VERSION=$1

echo "📊 Flyway Info Pré-Validação"

docker run --rm --network host \
  -v "${GITHUB_WORKSPACE}:/workspace" \
  -w /workspace \
  -e FLYWAY_URL -e FLYWAY_USER -e FLYWAY_PASSWORD \
  flyway/flyway:${FLYWAY_VERSION} \
  info

echo "✅ Flyway info executado"
