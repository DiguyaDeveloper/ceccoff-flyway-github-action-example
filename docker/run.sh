#!/bin/bash

ENV=${1:-dev}
COMMAND=${2:-info}

# Carrega variáveis do ambiente
source "../env/${ENV}.env"

docker run --rm \
  -e FLYWAY_URL \
  -e FLYWAY_USER \
  -e FLYWAY_PASSWORD \
  -e FLYWAY_PLACEHOLDER_SCHEMA \
  -v "$(pwd)/../sql:/flyway/sql" \
  flyway/flyway:9.22.3-alpine \
  ${COMMAND}
