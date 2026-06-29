---
name: springblog
description: Downloads Spring Blog articles filtered by topic and converts them to clean Markdown using pandoc
---

# SpringBlog Skill

This skill helps you download Spring Blog articles filtered by topic, extract their content, and convert them to clean markdown.

## When to Use This Skill

Use this skill when the user:
- Wants to download Spring Blog articles related to a specific topic (e.g., "Spring AI", "Spring Boot")
- Needs to archive or index Spring blog content for offline reading or RAG
- Wants to batch-convert Spring blog posts to clean markdown

## Prerequisites

- `curl` — for fetching data
- `pandoc` (>= 3.x) — for HTML-to-markdown conversion with Lua filters
- `jq` — for JSON parsing

## How It Works

The Spring Blog is a Gatsby site. All content lives in JSON API endpoints, not in the rendered HTML page.

### Architecture

```
https://spring.io/page-data/blog/category/engineering/page-data.json   ← full article list (metadata)
https://spring.io/page-data/blog/{path}/page-data.json                 ← per-article content (HTML body)
```

Each article's page-data.json contains a `result.data.post.html` field with the article body as clean HTML (no nav, no footer, no JS — just the content).

### Step 1: Discover Articles

Fetch the category listing to get all article metadata:

```bash
curl -sL "https://spring.io/page-data/blog/category/engineering/page-data.json" \
  -o /tmp/spring_blog_data.json
```

Filter by topic (e.g., "Spring AI") using jq:

```bash
cat /tmp/spring_blog_data.json | jq -r '
[.result.data.posts.nodes[] |
  select(.frontmatter.title | test("keyword"; "i"))] |
  sort_by(.frontmatter.publishedAt) | reverse |
  .[] | .fields.path
' > /tmp/paths.txt
```

The `path` (e.g., `2026/06/23/spring-ai-self-correcting-structured-output`) becomes the URL slug:
- Blog URL: `https://spring.io/blog/{path}`
- Data URL: `https://spring.io/page-data/blog/{path}/page-data.json`

### Step 2: Download Article Content

For each article path, fetch the page-data.json and extract the HTML body:

```bash
while IFS= read -r path; do
  filename=$(echo "$path" | sed 's|.*/||')
  curl -sL "https://spring.io/page-data/blog/${path}/page-data.json" \
    | jq -r '.result.data.post.html // empty' \
    > "html/${filename}.html"
done < /tmp/paths.txt
```

### Step 3: Convert to Markdown

Use pandoc with the provided Lua filter:

```bash
pandoc -f html -t markdown_strict \
  --lua-filter <skill-dir>/clean_springblog.lua \
  "html/${filename}.html" -o "md/${filename}.md" --wrap=none
```

Or batch-convert all:

```bash
for f in html/*.html; do
  name=$(basename "$f" .html)
  pandoc -f html -t markdown_strict \
    --lua-filter <skill-dir>/clean_springblog.lua \
    "$f" -o "md/${name}.md" --wrap=none
done
```

## Lua Filter: clean_springblog.lua

The filter (`clean_springblog.lua`) handles Spring Blog specific cleanups:

- **Removes SVG permalink anchors** from headings (those SVG icons next to `##` headings)
- **Decodes HTML entities** in code blocks (`&#x3C;` → `<`, `&amp;` → `&`, etc.)
- **Strips style attributes** from all elements
- **Preserves images** (converts to `![alt](url)`)
- **Preserves links** (keeps `href` attribute)
- **Removes `<script>`, `<style>`** raw HTML blocks

The filter is tailored for the Spring Blog's specific HTML structure (extracted from page-data.json's `html` field).

## Complete Pipeline Script

Here is a complete, reusable script that does everything:

```bash
#!/bin/bash
# download_spring_blogs.sh — Download Spring Blog articles by keyword
# Usage: ./download_spring_blogs.sh "Spring AI" [category]

SKILL_DIR="<skill-dir>"
KEYWORD="${1:-Spring AI}"
CATEGORY="${2:-engineering}"
OUTDIR="spring_blogs_${KEYWORD// /_}"
FILTER="${SKILL_DIR}/clean_springblog.lua"

mkdir -p "${OUTDIR}/html" "${OUTDIR}/md"

echo "=== Fetching article list for keyword: ${KEYWORD} ==="

curl -sL "https://spring.io/page-data/blog/category/${CATEGORY}/page-data.json" \
  | jq -r --arg kw "$KEYWORD" '
      "# Articles matching: \($kw)",
      "",
      "| Date | Title | URL | Author |",
      "| --- | --- | --- | --- |",
      ([.result.data.posts.nodes[] |
        select(.frontmatter.title | test($kw; "i"))] |
        sort_by(.frontmatter.publishedAt) | reverse |
        .[] |
        "| \(.frontmatter.publishedAt) | \(.frontmatter.title) | https://spring.io/blog/\(.fields.path) | \(.frontmatter.author) |"),
      "",
      "_Total: \( [.result.data.posts.nodes[] | select(.frontmatter.title | test($kw; "i"))] | length ) articles_"
    ' > "${OUTDIR}/blog_source_url.md"

# Extract paths for batch download
curl -sL "https://spring.io/page-data/blog/category/${CATEGORY}/page-data.json" \
  | jq -r --arg kw "$KEYWORD" \
      '[.result.data.posts.nodes[] |
        select(.frontmatter.title | test($kw; "i"))] |
        sort_by(.frontmatter.publishedAt) | reverse |
        .[].fields.path' \
  > /tmp/spring_paths.txt

total=$(wc -l < /tmp/spring_paths.txt | tr -d ' ')
current=0
success=0

echo ""
echo "=== Downloading and converting ${total} articles ==="

while IFS= read -r path; do
  filename=$(echo "$path" | sed 's|.*/||')
  html_file="${OUTDIR}/html/${filename}.html"
  md_file="${OUTDIR}/md/${filename}.md"
  
  ((current++))
  echo "[${current}/${total}] ${filename} ..."
  
  html_content=$(curl -sL --max-time 30 \
    "https://spring.io/page-data/blog/${path}/page-data.json" \
    | jq -r '.result.data.post.html // empty')
  
  if [ -z "$html_content" ]; then
    echo "  WARN: Empty content, skipping"
    continue
  fi
  
  echo "$html_content" > "$html_file"
  
  pandoc -f html -t markdown_strict --lua-filter "$FILTER" \
    "$html_file" -o "$md_file" --wrap=none 2>/dev/null
  
  if [ -f "$md_file" ]; then
    ((success++))
    echo "  OK: HTML $(wc -c < "$html_file" | tr -d ' ')B → MD $(wc -c < "$md_file" | tr -d ' ')B"
  else
    echo "  ERROR: pandoc conversion failed"
  fi
done < /tmp/spring_paths.txt

echo ""
echo "=== Done: ${success}/${total} articles ==="
echo "Source list: ${OUTDIR}/blog_source_url.md"
echo "HTML files:  ${OUTDIR}/html/"
echo "Markdown:    ${OUTDIR}/md/"
```

## Example Usage

```bash
# Download all "Spring AI" articles from the Engineering category
bash download_spring_blogs.sh "Spring AI"

# Download "Spring Boot 4" articles
bash download_spring_blogs.sh "Spring Boot 4"

# Use a different category
bash download_spring_blogs.sh "Spring Security" "engineering"
```

## Notes

- **Video/Podcast posts** (e.g., "Spring Tips", "A Bootiful Podcast") often have minimal text content — the actual content is the embedded media. These will produce very short markdown files.
- The Spring Blog uses Gatsby 5. Content is in `page-data.json` files, not in the rendered HTML.
- The `html` field in page-data.json contains clean, self-contained article body HTML (no navigation, no sidebars, no external assets).
- Use `markdown_strict` output format for the most portable markdown.
- Articles are sorted by `publishedAt` in reverse chronological order.
- The Lua filter is specifically tuned for Spring Blog's HTML structure. It may need adjustments if the blog changes its markup.
