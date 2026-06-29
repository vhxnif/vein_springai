#!/bin/bash
# download_springai_docs.sh — Download Spring AI reference docs to markdown
# Usage: ./download_springai_docs.sh

set -euo pipefail

BASE_URL="https://docs.spring.io/spring-ai/reference"
OUTDIR="./springai2.0"
FILTER="/Users/chen/.agents/skills/readlink/clean_markdown.lua"
INDEX_URL="${BASE_URL}/index.html"

mkdir -p "$OUTDIR"

echo "=== Step 1: Discovering pages ==="
curl -sL "$INDEX_URL" | \
  grep -o 'href="[^"]*"' | sed 's/href="//;s/"//' | \
  grep '\.html$' | grep -v '^https\?://' | grep -v '^[0-9]' | sort -u > /tmp/pages.txt

total=$(wc -l < /tmp/pages.txt | tr -d ' ')
echo "Found ${total} pages"
echo ""

current=0
success=0
failed=0

echo "=== Step 2: Downloading and converting ==="
while IFS= read -r page; do
  ((current++))
  url="${BASE_URL}/${page}"
  outfile="${OUTDIR}/${page%.html}.md"
  outdir=$(dirname "$outfile")
  
  mkdir -p "$outdir"
  
  printf "[%3d/%3d] %s ... " "$current" "$total" "$page"
  
  if curl -sL --max-time 30 "$url" | \
     pandoc -f html -t markdown_strict --lua-filter "$FILTER" \
       -o "$outfile" --wrap=none 2>/dev/null; then
    size=$(wc -c < "$outfile" | tr -d ' ')
    if [ "$size" -lt 100 ]; then
      echo "WARN (${size}B, likely nav-only)"
      ((success++))
    else
      echo "OK (${size}B)"
      ((success++))
    fi
  else
    echo "FAIL"
    ((failed++))
  fi
done < /tmp/pages.txt

rm -f /tmp/pages.txt

echo ""
echo "=== Done ==="
echo "Total:   ${total}"
echo "Success: ${success}"
echo "Failed:  ${failed}"
echo "Output:  ${OUTDIR}/"
