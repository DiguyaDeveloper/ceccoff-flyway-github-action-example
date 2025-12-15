#!/bin/bash
set -e

echo "::group::📊 Gerando Relatório Final da Action"

# Capturar informações da execução
WORKFLOW_NAME="${GITHUB_WORKFLOW:-Desconhecido}"
BRANCH_NAME="${GITHUB_REF_NAME:-Desconhecido}"
COMMIT_SHA="${GITHUB_SHA:-Desconhecido}"
ACTOR="${GITHUB_ACTOR:-Desconhecido}"
RUN_ID="${GITHUB_RUN_ID:-Desconhecido}"
REPOSITORY="${GITHUB_REPOSITORY:-Desconhecido}"

# Status dos jobs (passado via env)
VALIDATE_JOB_RESULT="${VALIDATE_JOB_STATUS:-skipped}"
MIGRATE_REMOTE_JOB_RESULT="${MIGRATE_REMOTE_JOB_STATUS:-skipped}"
MIGRATE_LOCAL_JOB_RESULT="${MIGRATE_LOCAL_JOB_STATUS:-skipped}"

# Mapear status para mensagens legíveis
case "$VALIDATE_JOB_RESULT" in
  "success") VALIDATE_JOB_STATUS="✅ Validação bem-sucedida" ;;
  "failure") VALIDATE_JOB_STATUS="❌ Falha na validação" ;;
  "cancelled") VALIDATE_JOB_STATUS="⚠️ Validação cancelada" ;;
  "skipped") VALIDATE_JOB_STATUS="⏭️ Validação pulada" ;;
  *) VALIDATE_JOB_STATUS="❓ Status desconhecido: $VALIDATE_JOB_RESULT" ;;
esac

# Determinar status da migração (priorizar remote se executado, senão local)
if [[ "$MIGRATE_REMOTE_JOB_RESULT" != "skipped" ]]; then
  MIGRATE_JOB_RESULT="$MIGRATE_REMOTE_JOB_RESULT"
  MIGRATE_JOB_TYPE="Ambiente"
else
  MIGRATE_JOB_RESULT="$MIGRATE_LOCAL_JOB_RESULT"
  MIGRATE_JOB_TYPE="Local"
fi

case "$MIGRATE_JOB_RESULT" in
  "success") MIGRATE_JOB_STATUS="✅ Migração executada com sucesso ($MIGRATE_JOB_TYPE)" ;;
  "failure") MIGRATE_JOB_STATUS="❌ Falha na migração ($MIGRATE_JOB_TYPE)" ;;
  "cancelled") MIGRATE_JOB_STATUS="⚠️ Migração cancelada ($MIGRATE_JOB_TYPE)" ;;
  "skipped") MIGRATE_JOB_STATUS="⏭️ Migração pulada" ;;
  *) MIGRATE_JOB_STATUS="❓ Status desconhecido: $MIGRATE_JOB_RESULT ($MIGRATE_JOB_TYPE)" ;;
esac

# Determinar status geral baseado nos resultados brutos
if [[ "$VALIDATE_JOB_RESULT" == "success" ]] && [[ "$MIGRATE_JOB_RESULT" == "success" || "$MIGRATE_JOB_RESULT" == "skipped" ]]; then
    OVERALL_STATUS="✅ Sucesso Total"
elif [[ "$VALIDATE_JOB_RESULT" == "failure" || "$MIGRATE_JOB_RESULT" == "failure" ]]; then
    OVERALL_STATUS="❌ Falhou"
elif [[ "$VALIDATE_JOB_RESULT" == "cancelled" || "$MIGRATE_JOB_RESULT" == "cancelled" ]]; then
    OVERALL_STATUS="⚠️ Parcial"
else
    OVERALL_STATUS="❓ Status Indeterminado"
fi

echo "🔍 Coletando informações da execução..."
echo "📊 Preparando relatório visual..."

# Criar relatório detalhado para o Summary
SUMMARY="## 🚀 Relatório Final da Action - $OVERALL_STATUS

### 📋 Informações da Execução
- **Workflow:** $WORKFLOW_NAME
- **Branch:** \`$BRANCH_NAME\`
- **Commit:** \`${COMMIT_SHA:0:7}\`
- **Executado por:** @$ACTOR
- **Data/Hora:** $(date)
- **Run ID:** [$RUN_ID]($GITHUB_SERVER_URL/$REPOSITORY/actions/runs/$RUN_ID)

### 🎯 Status dos Jobs

| Job | Status | Descrição |
|-----|--------|-----------|
| 🔍 Validar Scripts | $VALIDATE_JOB_STATUS | Validação de estrutura, sintaxe e nomenclatura |
| 🚀 Executar Migração | $MIGRATE_JOB_STATUS | Aplicação das migrações no banco |

### 📁 Arquivos SQL Processados

| Arquivo | Tipo | Status |
|---------|------|--------|"

# Adicionar arquivos DDL
find sql/ddl -name "*.sql" 2>/dev/null | while read -r file; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        SUMMARY="$SUMMARY
| \`$filename\` | DDL | ✅ Processado |"
    fi
done

# Adicionar arquivos Repeatable
find sql/repeatable -name "*.sql" 2>/dev/null | while read -r file; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        SUMMARY="$SUMMARY
| \`$filename\` | Repeatable | ✅ Processado |"
    fi
done

# Adicionar arquivos DML
find sql/dml -name "*.sql" 2>/dev/null | while read -r file; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        SUMMARY="$SUMMARY
| \`$filename\` | DML | ✅ Processado |"
    fi
done

SUMMARY="$SUMMARY

### 📈 Estatísticas Finais
- **Total de arquivos SQL:** $(find sql -name "*.sql" | wc -l)
- **Arquivos DDL:** $(find sql/ddl -name "*.sql" 2>/dev/null | wc -l)
- **Arquivos DML:** $(find sql/dml -name "*.sql" 2>/dev/null | wc -l)
- **Arquivos Repeatable:** $(find sql/repeatable -name "*.sql" 2>/dev/null | wc -l)
- **Tempo de execução:** $(date -u +%H:%M:%S)

### 🔗 Links Importantes
- [📋 Ver logs completos]($GITHUB_SERVER_URL/$REPOSITORY/actions/runs/$RUN_ID)
- [📁 Ver arquivos SQL]($GITHUB_SERVER_URL/$REPOSITORY/tree/$BRANCH_NAME/sql)
- [🔄 Re-executar workflow]($GITHUB_SERVER_URL/$REPOSITORY/actions/workflows)

---
*Relatório gerado automaticamente - Flyway Database Migrations*"

# Salvar no GitHub Step Summary (ou arquivo local para teste)
if [[ -n "$GITHUB_STEP_SUMMARY" ]]; then
    echo "$SUMMARY" >> $GITHUB_STEP_SUMMARY
else
    # Para testes locais, salvar em arquivo
    echo "$SUMMARY" > report-output.md
    echo "📄 Relatório salvo em: report-output.md"
fi

echo "✅ Relatório final gerado"
echo "::endgroup::"
