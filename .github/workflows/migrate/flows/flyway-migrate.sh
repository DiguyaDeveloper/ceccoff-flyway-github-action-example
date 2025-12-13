#!/bin/bash
set -e

FLYWAY_VERSION=$1
COMMAND=$2

echo "🚀 Executando Flyway $COMMAND"

docker run --rm --network host \
  -v "${GITHUB_WORKSPACE}:/workspace" \
  -w /workspace \
  -e FLYWAY_URL -e FLYWAY_USER -e FLYWAY_PASSWORD \
  flyway/flyway:${FLYWAY_VERSION} \
  $COMMAND

echo "✅ Flyway $COMMAND executado"
