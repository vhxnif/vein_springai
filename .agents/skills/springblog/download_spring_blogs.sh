#!/bin/bash
# download_spring_blogs.sh — Download Spring Blog articles by keyword
# Usage: ./download_spring_blogs.sh "Spring AI" [category]
#
# Prerequisites: curl, jq, pandoc (>= 3.x)

set -euo pipefail

SKILL_DIR="$(cd "$(dirname "$0")" && pwd)"
KEYWORD="${1:-}"
CATEGORY="${2:-engineering}"

if [ -z "$KEYWORD" ]; then
  echo "Usage: $0 <keyword> [category]"
  echo "Example: $0 \"Spring AI\""
  echo "         $0 \"Spring Boot 4\" engineering"
  exit 1
fi

OUTDIR="./spring_blogs_$(echo "$KEYWORD" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')"
FILTER="${SKILL_DIR}/clean_springblog.lua"
PAGE_DATA_URL="https://spring.io/page-data/blog/category/${CATEGORY}/page-data.json"

if [ ! -f "$FILTER" ]; then
  echo "ERROR: Lua filter not found: $FILTER"
  exit 1
fi

# Check prerequisites
for cmd in curl jq pandoc; do
  if ! command -v $cmd &>/dev/null; then
    echo "ERROR: $cmd is required but not installed."
    exit 1
  fi
done

mkdir -p "${OUTDIR}/html" "${OUTDIR}/md"

echo "=== Fetching article list ==="
echo "URL:      ${PAGE_DATA_URL}"
echo "Keyword:  ${KEYWORD}"
echo "Category: ${CATEGORY}"
echo "Output:   ${OUTDIR}"
echo ""

# Generate source list markdown
curl -sL "$PAGE_DATA_URL" \
  | jq -r --arg kw "$KEYWORD" '
      "# Spring Blog Articles: \($kw)",
      "",
      "> Filtered from [Spring Blog - \( .result.data.posts.nodes[0].frontmatter.category // "Engineering")](https://spring.io/blog/category/engineering?filter=articles)",
      "",
      "| # | Date | Title | Author |",
      "| --- | --- | --- | --- |",
      ([.result.data.posts.nodes[] |
        select(.frontmatter.title | test($kw; "i"))] |
        sort_by(.frontmatter.publishedAt) | reverse |
        to_entries |
        .[] |
        "| \(.key + 1) | \(.value.frontmatter.publishedAt) | [\(.value.frontmatter.title)](https://spring.io/blog/\(.value.fields.path)) | \(.value.frontmatter.author) |"),
      "",
      "_Total: \( [.result.data.posts.nodes[] | select(.frontmatter.title | test($kw; "i"))] | length ) articles_"
    ' > "${OUTDIR}/blog_source_url.md"

# Extract paths for batch download
curl -sL "$PAGE_DATA_URL" \
  | jq -r --arg kw "$KEYWORD" \
      '[.result.data.posts.nodes[] |
        select(.frontmatter.title | test($kw; "i"))] |
        sort_by(.frontmatter.publishedAt) | reverse |
        .[].fields.path' \
  > /tmp/spring_paths.txt

total=$(wc -l < /tmp/spring_paths.txt | tr -d ' ')
if [ "$total" -eq 0 ]; then
  echo "No articles matching '${KEYWORD}' found."
  exit 0
fi

current=0
success=0
failed=0

echo "=== Downloading and converting ${total} articles ==="
echo ""

while IFS= read -r path; do
  filename=$(echo "$path" | sed 's|.*/||')
  html_file="${OUTDIR}/html/${filename}.html"
  md_file="${OUTDIR}/md/${filename}.md"
  
  ((current++))
  printf "[%2d/%2d] %s ... " "$current" "$total" "$filename"
  
  html_content=$(curl -sL --max-time 30 \
    "https://spring.io/page-data/blog/${path}/page-data.json" \
    | jq -r '.result.data.post.html // empty')
  
  if [ -z "$html_content" ]; then
    echo "SKIP (empty content)"
    ((failed++))
    continue
  fi
  
  echo "$html_content" > "$html_file"
  
  if pandoc -f html -t markdown_strict --lua-filter "$FILTER" \
    "$html_file" -o "$md_file" --wrap=none 2>/dev/null; then
    html_size=$(wc -c < "$html_file" | tr -d ' ')
    md_size=$(wc -c < "$md_file" | tr -d ' ')
    echo "OK (${html_size}B → ${md_size}B)"
    ((success++))
  else
    echo "FAIL (pandoc error)"
    ((failed++))
  fi
done < /tmp/spring_paths.txt

rm -f /tmp/spring_paths.txt

echo ""
echo "=== Done ==="
echo "Total:    ${total}"
echo "Success:  ${success}"
echo "Failed:   ${failed}"
echo ""
echo "Files created:"
echo "  ${OUTDIR}/blog_source_url.md  — article list with links"
echo "  ${OUTDIR}/html/               — raw HTML ($(ls ${OUTDIR}/html/*.html 2>/dev/null | wc -l | tr -d ' ') files)"
echo "  ${OUTDIR}/md/                 — clean Markdown ($(ls ${OUTDIR}/md/*.md 2>/dev/null | wc -l | tr -d ' ') files)"
