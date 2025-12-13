# Testes locais com `act` e Postgres

Este guia descreve os passos mínimos para testar o workflow de migração unificado (`.github/workflows/flyway-migrate.yml`) em modo local usando o `act` e o Postgres em Docker.

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

## 1) Preparação do Ambiente

### Limpar o ambiente Docker (recomendado para começar do zero)

Se houver containers ou volumes antigos, limpe-os:

```bash
# Parar e remover containers
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

# Remover imagens (opcional)
docker rmi $(docker images -q) --force

# Remover volumes, especialmente o pgdata
docker volume rm docker_pgdata
```

### Iniciar o Postgres de teste

O repositório contém um `docker-compose` de testes em `docker/docker-compose.yml`.

No diretório raiz do repositório rode:

```bash
cd docker
docker-compose up -d

# confirmar
docker ps | grep local-postgres

# verificar acesso ao banco
docker exec -i local-postgres psql -U app -d appdb -c "SELECT 1;"

# configurar autenticação (necessário para conexões externas)
docker exec -i local-postgres bash -c "echo 'host all all 0.0.0.0/0 trust' >> /var/lib/postgresql/data/pg_hba.conf"
docker exec -i local-postgres psql -U app -d appdb -c "SELECT pg_reload_conf();"

# listar tabelas no schema `scheduler` (onde as migrations são aplicadas)
docker exec -i local-postgres psql -U app -d appdb -c "\dt scheduler.*"
```

Se tudo estiver ok, o container `local-postgres` deverá estar em execução e responder ao `psql`.

## 2) Rodar o workflow local completo com `act` (simulando aprovação)

Este repositório tem suporte para simular aprovação manual localmente usando secrets para credenciais.

Execute (no Git Bash/terminal do projeto):

```bash
act -j validate --input environment=local \
  --secret DB_URL=jdbc:postgresql://localhost:5432/appdb \
  --secret DB_USER=app \
  --secret DB_PASS=app
```

Para executar a migração completa:

```bash
act -j migrate_local --input environment=local --input approved=true --input command=migrate \
  --secret DB_URL=jdbc:postgresql://localhost:5432/appdb \
  --secret DB_USER=app \
  --secret DB_PASS=app
```

O que isso faz:
- Roda os passos de validação (sqlfluff, nomenclatura, Flyway info)
- Simula a aprovação manual (o workflow detecta `approved=true` e executa a migração)
- Usa `--network host` nos containers Docker para conectar ao Postgres local.

Observações úteis:
- O workflow foi configurado para usar secrets para credenciais locais, pois inputs não funcionam bem no act.
- Se o `act` reclamar sobre tokens (ex.: `github-token`), você pode passar um token de teste via `-s GITHUB_TOKEN=...`, porém não é necessário para a simulação.
- Certifique-se de que o pg_hba.conf foi configurado para trust, como no passo 1.

## 3) Alternativa: rodar o Flyway manualmente (debug)

Se preferir rodar o Flyway manualmente fora do `act` (útil para debugging de montagem / conexão):

```bash
# no Git Bash no Windows (usando caminho Windows para montar corretamente)
docker run --rm --network host -v "$(pwd -W)/sql:/flyway/sql" \
  -e FLYWAY_URL=jdbc:postgresql://localhost:5432/appdb \
  -e FLYWAY_USER=app -e FLYWAY_PASSWORD=app \
  flyway/flyway:10 info
```

Para aplicar migrações:

```bash
docker run --rm --network host -v "$(pwd -W)/sql:/flyway/sql" \
  -e FLYWAY_URL=jdbc:postgresql://localhost:5432/appdb \
  -e FLYWAY_USER=app -e FLYWAY_PASSWORD=app \
  flyway/flyway:10 migrate
```

Nota: Use `--network host` para conectar ao Postgres local.

## Automatizar todo o fluxo com um script

Existe um helper no repositório que automatiza os passos acima: `./scripts/run-local-tests.sh`.

O script realiza, em sequência:
- Limpa o ambiente Docker (remove containers, imagens e volumes)
- Sobe o `docker-compose` de testes (`docker/docker-compose.yml`)
- Aguarda o Postgres estar pronto (usa `pg_isready`)
- Configura o pg_hba.conf para trust
- Executa o workflow local via `act` em modo simulado
- Lista as tabelas do schema `scheduler` para verificação rápida

Uso rápido:

```bash
./scripts/run-local-tests.sh
```

Para desmontar o ambiente após os testes:

```bash
cd docker
docker-compose down -v
```


Nota: quando executar manualmente a partir do host, use `$(pwd -W)` no Git Bash para o Docker no Windows montar corretamente o diretório.

## 4) Troubleshooting rápido

- Erro: `Connection refused` ou autenticação falhando
  - Causa: pg_hba.conf não configurado. Execute os comandos de configuração no passo 1.
  - Solução: Adicione `host all all 0.0.0.0/0 trust` ao pg_hba.conf e recarregue.

- Erro: `Skipping filesystem location: /flyway/sql/ddl (not found)`
  - Causa: montagem incorreta do diretório. Solução: use `--network host` e `$(pwd -W)` no Git Bash.

- Erro: `Detected applied migration not resolved locally: ...`
  - Causa: Flyway detecta migrações aplicadas que não existem localmente. Limpe o volume do Docker e comece do zero.

- `actions/github-script` falhando no `act` por `github-token` ausente
  - Em execuções locais com `act` é comum faltar `GITHUB_TOKEN`. O workflow local foi ajustado para pular a notificação quando `approved=true`.

- Erro no act com inputs não funcionando
  - Solução: Use secrets em vez de inputs para credenciais locais.

## 5) Dicas finais

- Sempre limpe o volume do Docker (`docker volume rm docker_pgdata`) para começar com um banco limpo.
- Configure o pg_hba.conf para trust para evitar problemas de autenticação.
- Use `--network host` nos comandos Docker para conectar ao Postgres local.
- Para testes locais fiéis, use secrets com act em vez de inputs.
- Em CI real (GitHub Actions) mantenha proteções de `Environment` para `hml`/`prod` e deixe o `approval_local` presente — no GitHub a execução irá pausar e aguardar aprovadores.
