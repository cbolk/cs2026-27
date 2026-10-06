#!/usr/bin/env bash

# Uso: ./generapdf.sh nome-file [C]
# Il primo argomento e' il nome senza l'estensione .md; con "C" vengono
# mantenuti anche i blocchi di codice C.
set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
    echo "Uso: $0 nome-file [C]" >&2
    exit 2
fi

SRCDIR="../calendario"
OUTDIR="../pdf"
METADATA="cs.yaml"
FILTER_EXE="lua_numeraesercizi.lua"
FILTER_KW="lua_keywords.lua"
LATEX_HEADER="filesingolo.tex"
PDF_ENGINE="${PDF_ENGINE:-xelatex}"

input_file="$SRCDIR/$1.md"
mode="${2:-}"

if [[ ! -f "$input_file" ]]; then
    echo "File non trovato: $input_file" >&2
    exit 1
fi

mkdir -p "$OUTDIR"

pandoc_common=(
	"--metadata-file=$METADATA"
    "--pdf-engine=$PDF_ENGINE"
    -H "$LATEX_HEADER"
    -V geometry:margin=2cm
    --filter pandoc-crossref
    --syntax-highlighting=idiomatic
    -M listings
    "--lua-filter=$FILTER_EXE"
    "--lua-filter=$FILTER_KW"
)

if [[ "$mode" == "PY" ]]; then
    sed -e '/^\[file\]/d' "$input_file" |
        pandoc "${pandoc_common[@]}" -o "$OUTDIR/$1.full.pdf"
else
    sed -e '/```python/,/```/d' -e '/^\[file\]/d' "$input_file" |
        pandoc "${pandoc_common[@]}" -o "$OUTDIR/$1.pdf"
fi
