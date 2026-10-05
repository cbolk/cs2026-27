function Pandoc(doc)
  -- 1. Legge il valore iniziale dal metadato
  local alg = doc.meta["alg-start"]
  local algcounter = 0
  local algpro = doc.meta["algpro-start"]
  local algcounterpro = 0
  local start = doc.meta["exe-start"]  
  local counter = 0
  local startpro = doc.meta["exepro-start"]
  local counterpro = 0

  if alg then
    local s = pandoc.utils.stringify(alg)
    algcounter = tonumber(s) - 1  -- es: exepro-start: 5 -> parte da 5
  end
  if algpro then
    local s = pandoc.utils.stringify(algpro)
    algcounterpro = tonumber(s) - 1  -- es: exepro-start: 5 -> parte da 5
  end
  if start then
    local s = pandoc.utils.stringify(start)
    counter = tonumber(s) - 1  -- es: exe-start: 5 -> parte da 5
  end
  if startpro then
    local s = pandoc.utils.stringify(startpro)
    counterpro = tonumber(s) - 1  -- es: exepro-start: 5 -> parte da 5
  end

  -- 2. Scorre tutti i blocchi del documento
  for i,el in ipairs(doc.blocks) do
    if el.t == "Div" and el.classes:includes('algfatti') then
      algcounter = algcounter + 1
      local numero = pandoc.Para{pandoc.Strong(pandoc.Str("Algoritmi svolti #" .. algcounter .. ":"))}
      -- Inserisce il numero prima del contenuto del blocco
      el.content = {numero, table.unpack(el.content)}
      doc.blocks[i] = el
    elseif el.t == "Div" and el.classes:includes('algpro') then
      algcounterpro = algcounterpro + 1
      local numero = pandoc.Para{pandoc.Strong(pandoc.Str("Algoritmi proposti #" .. algcounterpro .. ":"))}
      -- Inserisce il numero prima del contenuto del blocco
      el.content = {numero, table.unpack(el.content)}
      doc.blocks[i] = el
    elseif el.t == "Div" and el.classes:includes('exefatti') then
      counter = counter + 1
      local numero = pandoc.Para{pandoc.Strong(pandoc.Str("Esercizio svolto #" .. counter .. ":"))}
      -- Inserisce il numero prima del contenuto del blocco
      el.content = {numero, table.unpack(el.content)}
      doc.blocks[i] = el
    elseif el.t == "Div" and el.classes:includes('exepro') then
      counterpro = counterpro + 1
      local numero = pandoc.Para{pandoc.Strong(pandoc.Str("Esercizio proposto #" .. counterpro .. ":"))}
      -- Inserisce il numero prima del contenuto del blocco
      el.content = {numero, table.unpack(el.content)}
      doc.blocks[i] = el
    end
  end

  -- 3. Restituisce il documento modificato
  return doc
end
