#!/usr/bin/env bash
#
# genera_pdf.sh
#
# Genera un PDF stampabile per ogni file .md in calendario/, usando pandoc.
# Applica il filtro numera_esercizi.lua per numerare in automatico gli
# esercizi svolti/proposti a partire da exe-start / exepro-start nel
# frontmatter di ciascun file. I PDF vengono scritti in pdf/, mantenendo
# lo stesso nome del file sorgente
# (es. calendario/20260922.md -> pdf/20260922.pdf).
#
# Requisiti: pandoc >= 2.17, un motore LaTeX (es. texlive per xelatex).
#
# Uso:
#   ./script/genera_pdf.sh              # converte tutti i file in calendario/
#   ./script/genera_pdf.sh 20260922     # converte solo calendario/20260922*.md

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$ROOT_DIR/calendario"
OUT_DIR="$ROOT_DIR/pdf"
FILTER_FILE="$ROOT_DIR/script/numera_esercizi.lua"
FILTER="${1:-}"

mkdir -p "$OUT_DIR"

if ! command -v pandoc >/dev/null 2>&1; then
    echo "Errore: pandoc non è installato o non è nel PATH." >&2
    exit 1
fi

shopt -s nullglob
for src in "$SRC_DIR"/*"$FILTER"*.md; do
    name="$(basename "$src" .md)"
    out="$OUT_DIR/$name.pdf"
    echo "Genero $out"
    pandoc "$src" \
        --from=markdown+fenced_divs \
        --lua-filter="$FILTER_FILE" \
        --pdf-engine=xelatex \
        -V geometry:margin=2.5cm \
        -o "$out"
done

echo "Fatto. PDF disponibili in $OUT_DIR"
