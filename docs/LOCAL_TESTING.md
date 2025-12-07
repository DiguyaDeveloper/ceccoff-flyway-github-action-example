# Testes locais com `act` e Postgres

Este guia descreve os passos mínimos para testar o workflow local de migração (`.github/workflows/db-migrate-local.yml`) usando o `act` e o Postgres em Docker.

## Pré-requisitos
- Docker Desktop (Windows) ou Docker Engine instalado e rodando
- Git Bash (ou WSL) no Windows, ou um shell compatível com Bash
- `docker-compose` (no repositório existe `docker/docker-compose.yml`)
- `act` (ferramenta para rodar GitHub Actions localmente)

## Instalar o `act`

Opções recomendadas (Windows):

- Via Scoop (se instalado):

```bash
scoop install act
```

- Via Chocolatey (se preferir):

```powershell
choco install act
```

- Ou baixe a versão mais recente em: https://github.com/nektos/act/releases

Observação: escolha a forma que preferir. Depois de instalado, confirme com `act --version`.

## 1) Iniciar o Postgres de teste

O repositório contém um `docker-compose` de testes em `docker/docker-compose.yml`.

No diretório raiz do repositório rode:

```bash
docker-compose -f docker/docker-compose.yml up -d

# confirmar
docker ps | grep local-postgres

# verificar acesso ao banco
docker exec -i local-postgres psql -U app -d appdb -c "SELECT 1;"

# listar tabelas no schema `scheduler` (onde as migrations são aplicadas)
docker exec -i local-postgres psql -U app -d appdb -c "\dt scheduler.*"
```

Se tudo estiver ok, o container `local-postgres` deverá estar em execução e responder ao `psql`.

## 2) Rodar o workflow local completo com `act` (simulando aprovação)

Este repositório tem suporte para simular aprovação manual localmente usando o input `approved=true`.

Execute (no Git Bash/terminal do projeto):

```bash
act -W .github/workflows/db-migrate-local.yml -j migrate_local \
  --input environment=dev \
  --input command=migrate \
  --input approved=true
```

O que isso faz:
- Roda os passos de validação (sqlfluff, nomenclatura)
- Simula a aprovação manual (o workflow detecta `approved=true` e usa essa simulação)
- Em modo de simulação, o workflow baixa o Flyway CLI dentro do runner e executa a migração lendo `sql/` do workspace (evita problemas de montagem com `docker run` dentro do container do `act`).

Observações úteis:
- Se o `act` reclamar sobre tokens (ex.: `github-token`), você pode passar um token de teste via `-s GITHUB_TOKEN=...`, porém não é necessário para a simulação (o workflow já pula a notificação quando `approved=true`).
- Se seu sistema for Windows e você precisar montar caminhos em containers manualmente, use `$(pwd -W)` para obter o caminho no formato Windows (útil para comandos `docker run` manuais abaixo).

## 3) Alternativa: rodar o Flyway manualmente (debug)

Se preferir rodar o Flyway manualmente fora do `act` (útil para debugging de montagem / conexão):

```bash
# no Git Bash no Windows (usando caminho Windows para montar corretamente)
docker run --rm -v "$(pwd -W)/sql:/flyway/sql" \
  -e FLYWAY_URL=jdbc:postgresql://host.docker.internal:5432/appdb \
  -e FLYWAY_USER=app -e FLYWAY_PASSWORD=app \
  -e FLYWAY_SCHEMAS=scheduler -e FLYWAY_DEFAULT_SCHEMA=scheduler \
  flyway/flyway:10.18.2 migrate
```

Ou (modo leitura das pastas `ddl` e `repeatable` explicitamente):

```bash
docker run --rm -v "$(pwd -W)/sql:/flyway/sql" \
  -e FLYWAY_URL=jdbc:postgresql://host.docker.internal:5432/appdb \
  -e FLYWAY_USER=app -e FLYWAY_PASSWORD=app \
  -e FLYWAY_LOCATIONS=filesystem:/flyway/sql/ddl,filesystem:/flyway/sql/repeatable \
  flyway/flyway:10.18.2 info
```

## Automatizar todo o fluxo com um script

Existe um helper no repositório que automatiza os passos acima: `./scripts/run-local-tests.sh`.

O script realiza, em sequência:
- Sobe o `docker-compose` de testes (`docker/docker-compose.yml`)
- Aguarda o Postgres estar pronto (usa `pg_isready`)
- Executa o workflow local via `act` em modo simulado (`approved=true`)
- Lista as tabelas do schema `scheduler` para verificação rápida

Uso rápido:

```bash
./scripts/run-local-tests.sh
```

Para desmontar o ambiente após os testes:

```bash
docker-compose -f docker/docker-compose.yml down -v
```


Nota: quando executar manualmente a partir do host, use `$(pwd -W)` no Git Bash para o Docker no Windows montar corretamente o diretório.

## 4) Troubleshooting rápido

- Erro: `Skipping filesystem location: /flyway/sql/ddl (not found)`
  - Causa: montagem incorreta do diretório dentro do container (comum ao `docker run` executado a partir de outro container). Solução: usar `approved=true` com `act` (o workflow passa a usar Flyway CLI) ou executar `docker run` diretamente no host com `$(pwd -W)`.

- Erro: `Detected applied migration not resolved locally: ...`
  - Causa: Flyway detecta no banco migrações aplicadas que não existem localmente. Verifique se você está apontando para o banco correto e se as pastas `sql/ddl` e `sql/repeatable` contêm os mesmos scripts aplicados anteriormente. Use `flyway repair` com cautela.

- `actions/github-script` falhando no `act` por `github-token` ausente
  - Em execuções locais com `act` é comum faltar `GITHUB_TOKEN`. O workflow local foi ajustado para pular a notificação quando `approved=true`. Para testes avançados você pode exportar `-s GITHUB_TOKEN=xxx` ao chamar `act`.

## 5) Dicas finais

- Para testes locais fiéis, use `approved=true` com `act` — o workflow baixará o Flyway CLI e executará as migrações lendo o workspace.
- Em CI real (GitHub Actions) mantenha proteções de `Environment` para `hml`/`prod` e deixe o `approval_local` presente — no GitHub a execução irá pausar e aguardar aprovadores.
