#!/bin/bash
set -e

echo "📝 Validando Sintaxe SQL com sqlfluff"

pip install sqlfluff --break-system-packages

echo "::group::Validação de Scripts SQL"
find sql -type f -name "*.sql" -exec sqlfluff lint {} \;
echo "::endgroup::"

echo "✅ Sintaxe SQL validada"
