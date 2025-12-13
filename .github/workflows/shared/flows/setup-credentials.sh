#!/bin/bash
set -e

ENVIRONMENT=$1
DB_URL=$2
DB_USER=$3
DB_PASS=$4

echo "🔐 Configurando Credenciais para $ENVIRONMENT"

if [ "$ENVIRONMENT" = "local" ]; then
  if [ -z "$DB_URL" ] || [ -z "$DB_USER" ] || [ -z "$DB_PASS" ]; then
    echo "::error::Para environment=local, forneça db_url, db_user e db_pass"
    exit 1
  fi
  echo "Usando credenciais fornecidas para local"
  echo "FLYWAY_URL=$DB_URL" >> $GITHUB_ENV
  echo "FLYWAY_USER=$DB_USER" >> $GITHUB_ENV
  echo "FLYWAY_PASSWORD=$DB_PASS" >> $GITHUB_ENV
else
  if [ -z "$DB_URL" ] || [ -z "$DB_USER" ] || [ -z "$DB_PASS" ]; then
    echo "::error::Defina os secrets DB_URL, DB_USER e DB_PASS para $ENVIRONMENT"
    exit 1
  fi
  echo "Usando secrets para $ENVIRONMENT"
  echo "FLYWAY_URL=$DB_URL" >> $GITHUB_ENV
  echo "FLYWAY_USER=$DB_USER" >> $GITHUB_ENV
  echo "FLYWAY_PASSWORD=$DB_PASS" >> $GITHUB_ENV
fi

echo "✅ Credenciais configuradas"
