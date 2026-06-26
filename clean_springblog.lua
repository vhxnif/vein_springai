-- clean_springblog.lua
-- Pandoc Lua filter for Spring blog articles
-- Extracted from page-data.json html field
-- Handles: SVG anchor links, HTML entities in code, inline SVG data URI icons

-- Remove anchor permalink links from headings (SVG anchor icons)
function Header(el)
  local new_content = {}
  for _, child in ipairs(el.content) do
    if child.tag == "Link" then
      local is_anchor = false
      for _, cls in ipairs(child.classes) do
        if cls == "anchor" then
          is_anchor = true
          break
        end
      end
      if not is_anchor then
        table.insert(new_content, child)
      end
    else
      table.insert(new_content, child)
    end
  end
  el.attributes = {}
  el.identifier = el.identifier or ""
  el.content = new_content
  return el
end

-- Images: remove inline SVG data-URI icons (embedded widgets),
-- keep real URL images (blog content), strip non-essential attrs
function Image(el)
  -- Remove data URI SVG icons from embedded widgets
  local src = el.src or ""
  if src:match("^data:image/svg") then
    return {}
  end
  -- Keep only essential attributes
  local keep = { src = true, alt = true, title = true }
  local cleaned = {}
  for k, v in pairs(el.attributes) do
    if keep[k] then
      cleaned[k] = v
    end
  end
  el.attributes = cleaned
  return el
end

-- Clean code blocks: unescape HTML entities
function CodeBlock(el)
  local text = el.text
  text = text:gsub("&#x3C;", "<")
  text = text:gsub("&#x3E;", ">")
  text = text:gsub("&#x27;", "'")
  text = text:gsub("&#x2F;", "/")
  text = text:gsub("&#39;", "'")
  text = text:gsub("&amp;", "&")
  text = text:gsub("&lt;", "<")
  text = text:gsub("&gt;", ">")
  text = text:gsub("&quot;", '"')
  el.text = text
  return el
end

-- Clean inline code: unescape HTML entities
function Code(el)
  local text = el.text
  text = text:gsub("&#x3C;", "<")
  text = text:gsub("&#x3E;", ">")
  text = text:gsub("&#x27;", "'")
  text = text:gsub("&#x2F;", "/")
  text = text:gsub("&#39;", "'")
  text = text:gsub("&amp;", "&")
  text = text:gsub("&lt;", "<")
  text = text:gsub("&gt;", ">")
  text = text:gsub("&quot;", '"')
  el.text = text
  return el
end

-- Remove raw HTML blocks (scripts, styles, comments)
function RawBlock(el)
  if el.format == "html" then
    local text = el.text:lower()
    if text:match("<script") or text:match("<style") or text:match("<!--") then
      return {}
    end
  end
  return el
end

-- Remove raw HTML inline (scripts, styles)
function RawInline(el)
  if el.format == "html" then
    local text = el.text:lower()
    if text:match("<script") or text:match("<style") then
      return {}
    end
  end
  return el
end

-- Links: keep only href, title
function Link(el)
  local keep = { href = true, title = true }
  local cleaned = {}
  for k, v in pairs(el.attributes) do
    if keep[k] then
      cleaned[k] = v
    end
  end
  el.attributes = cleaned
  return el
end

-- Div: strip all attributes
function Div(el)
  el.attributes = {}
  return el
end

-- Span: unwrap, keeping content only
function Span(el)
  return el.content
end

-- Table: pass through
function Table(e)
  return e
end

function TableCell(e)
  return e
end
