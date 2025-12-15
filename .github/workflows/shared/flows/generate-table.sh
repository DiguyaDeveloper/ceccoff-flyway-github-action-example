#!/bin/bash
set -e

echo "::group::📊 Gerando Relatório Detalhado dos Scripts SQL"

# Função para formatar tamanho de arquivo
format_size() {
    local size=$1
    if [ $size -gt 1048576 ]; then
        echo "$(( size / 1048576 ))MB"
    elif [ $size -gt 1024 ]; then
        echo "$(( size / 1024 ))KB"
    else
        echo "${size}B"
    fi
}

echo "🔍 Analisando arquivos SQL..."

# Header da tabela
echo "| Arquivo | Tipo | Tamanho | Modificado | Status |"
echo "|---------|------|---------|------------|--------|"

# Processar DDL files
find sql/ddl -name "*.sql" 2>/dev/null | while read -r file; do
    if [ -f "$file" ]; then
        size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo "0")
        formatted_size=$(format_size $size)
        modified=$(stat -f%Sm -t "%Y-%m-%d %H:%M" "$file" 2>/dev/null || stat -c"%y" "$file" 2>/dev/null | cut -d'.' -f1 || echo "N/A")
        filename=$(basename "$file")
        echo "| \`$filename\` | DDL | $formatted_size | $modified | ✅ OK |"
    fi
done

# Processar Repeatable files
find sql/repeatable -name "*.sql" 2>/dev/null | while read -r file; do
    if [ -f "$file" ]; then
        size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo "0")
        formatted_size=$(format_size $size)
        modified=$(stat -f%Sm -t "%Y-%m-%d %H:%M" "$file" 2>/dev/null || stat -c"%y" "$file" 2>/dev/null | cut -d'.' -f1 || echo "N/A")
        filename=$(basename "$file")
        echo "| \`$filename\` | Repeatable | $formatted_size | $modified | ✅ OK |"
    fi
done

# Processar DML files
find sql/dml -name "*.sql" 2>/dev/null | while read -r file; do
    if [ -f "$file" ]; then
        size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo "0")
        formatted_size=$(format_size $size)
        modified=$(stat -f%Sm -t "%Y-%m-%d %H:%M" "$file" 2>/dev/null || stat -c"%y" "$file" 2>/dev/null | cut -d'.' -f1 || echo "N/A")
        filename=$(basename "$file")
        echo "| \`$filename\` | DML | $formatted_size | $modified | ✅ OK |"
    fi
done

echo ""
echo "**Total de arquivos analisados:** $(find sql -name "*.sql" 2>/dev/null | wc -l)"
echo "**Data da análise:** $(date)"
echo "**Ambiente:** $ENVIRONMENT"

echo "::endgroup::"

echo "✅ Tabela detalhada gerada"
