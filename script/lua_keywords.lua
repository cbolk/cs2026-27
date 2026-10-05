local keywords = {}

-- Raccoglie le keyword marcate con {.kw}
function Span(el)
  if el.classes:includes("cc") then
    local text = pandoc.utils.stringify(el.content)
    keywords[text] = true
  end
end

function Pandoc(doc)
  if next(keywords) == nil then
    return doc
  end

  -- Costruisce lista ordinata
  local items = {}
  for k, _ in pairs(keywords) do
    table.insert(items, pandoc.Plain({ pandoc.Str(k) }))
  end

  table.sort(items, function(a, b)
    return pandoc.utils.stringify(a) < pandoc.utils.stringify(b)
  end)

  -- Header "Parole chiave"
  local blocks = {}
  table.insert(blocks, pandoc.Header(1, "Parole chiave"))

  -- Elenco puntato
  table.insert(blocks, pandoc.BulletList(items))

  -- Appende alla fine del documento
  for _, b in ipairs(blocks) do
    doc.blocks:insert(b)
  end

  return doc
end
