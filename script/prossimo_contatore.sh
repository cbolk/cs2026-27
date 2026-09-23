#!/usr/bin/env bash
#
# prossimo_contatore.sh
#
# Dato un file calendario/YYYYMMDD[.lab|.es].md, legge i suoi exe-start /
# exepro-start e conta quanti blocchi "::: exefatti" e "::: exepro"
# contiene, per suggerire i valori exe-start / exepro-start da mettere
# nel PROSSIMO file di calendario (così la numerazione degli esercizi
# resta progressiva lungo tutto il corso).
#
# Uso:
#   ./script/prossimo_contatore.sh calendario/20260922.md

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Uso: $0 <file .md in calendario/>" >&2
    exit 1
fi

file="$1"

if [ ! -f "$file" ]; then
    echo "Errore: file non trovato: $file" >&2
    exit 1
fi

exe_start=$(grep -m1 -E '^exe-start:' "$file" | sed -E 's/^exe-start:[[:space:]]*//')
exepro_start=$(grep -m1 -E '^exepro-start:' "$file" | sed -E 's/^exepro-start:[[:space:]]*//')

if [ -z "${exe_start:-}" ] || [ -z "${exepro_start:-}" ]; then
    echo "Errore: $file non ha frontmatter exe-start / exepro-start valido." >&2
    exit 1
fi

exe_count=$(grep -c -E '^:::[[:space:]]*exefatti' "$file" || true)
exepro_count=$(grep -c -E '^:::[[:space:]]*exepro' "$file" || true)

exe_next=$((exe_start + exe_count))
exepro_next=$((exepro_start + exepro_count))

echo "$file: $exe_count esercizi svolti, $exepro_count proposti."
echo "Frontmatter suggerito per il PROSSIMO file:"
echo "---"
echo "exe-start: $exe_next"
echo "exepro-start: $exepro_next"
echo "---"
