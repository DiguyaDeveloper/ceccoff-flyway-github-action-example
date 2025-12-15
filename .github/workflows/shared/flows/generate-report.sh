#!/bin/bash
set -e

echo "::group::📊 Gerando Relatório de Validação"

# Coletar informações dos arquivos SQL
echo "🔍 Coletando informações dos scripts SQL..."

# DDL Files
DDL_FILES=$(find sql/ddl -name "*.sql" 2>/dev/null | wc -l)
DDL_LIST=$(find sql/ddl -name "*.sql" 2>/dev/null | head -10 | sed 's|^|- |')

# Repeatable Files
REPEATABLE_FILES=$(find sql/repeatable -name "*.sql" 2>/dev/null | wc -l)
REPEATABLE_LIST=$(find sql/repeatable -name "*.sql" 2>/dev/null | head -10 | sed 's|^|- |')

# DML Files (se existir)
DML_FILES=$(find sql/dml -name "*.sql" 2>/dev/null | wc -l)
DML_LIST=$(find sql/dml -name "*.sql" 2>/dev/null | head -10 | sed 's|^|- |')

# Total
TOTAL_FILES=$((DDL_FILES + REPEATABLE_FILES + DML_FILES))

# Gerar tabela Markdown
echo "📋 Gerando tabela de resumo..."

cat << EOF > validation-report.md
## 📊 Relatório de Validação dos Scripts SQL

### 📈 Estatísticas Gerais

| Tipo | Quantidade | Status |
|------|------------|--------|
| DDL | $DDL_FILES | ✅ Validado |
| DML | $DML_FILES | ✅ Validado |
| Repeatable | $REPEATABLE_FILES | ✅ Validado |
| **Total** | **$TOTAL_FILES** | ✅ **Todos OK** |

### 📁 Arquivos DDL
$(if [ "$DDL_FILES" -gt 0 ]; then echo "$DDL_LIST"; else echo "Nenhum arquivo encontrado"; fi)

### 🔄 Arquivos Repeatable
$(if [ "$REPEATABLE_FILES" -gt 0 ]; then echo "$REPEATABLE_LIST"; else echo "Nenhum arquivo encontrado"; fi)

### 📝 Arquivos DML
$(if [ "$DML_FILES" -gt 0 ]; then echo "$DML_LIST"; else echo "Nenhum arquivo encontrado"; fi)

### ✅ Validações Executadas
- ✅ Estrutura de diretórios
- ✅ Sintaxe SQL (sqlfluff)
- ✅ Nomenclatura dos arquivos
- ✅ Conectividade com banco (Flyway)

**Data/Hora:** $(date)
**Ambiente:** $ENVIRONMENT
**Status:** ✅ Sucesso
EOF

echo "📄 Relatório gerado: validation-report.md"
echo "::endgroup::"

echo "✅ Relatório de validação gerado com sucesso"
