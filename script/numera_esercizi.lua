-- numera_esercizi.lua
--
-- Filtro pandoc che numera in modo progressivo i blocchi ::: exefatti :::
-- e ::: exepro ::: di un file .md, partendo dai valori exe-start /
-- exepro-start indicati nel frontmatter YAML del file.
--
-- Ad ogni blocco "exefatti" viene anteposta una riga "**Esercizio N**",
-- ad ogni blocco "exepro" una riga "**Esercizio proposto N**"; il
-- contatore corrispondente viene poi incrementato di 1.
--
-- Uso (vedi anche script/genera_pdf.sh):
--   pandoc file.md --from=markdown+fenced_divs --lua-filter=numera_esercizi.lua -o file.pdf
--
-- Richiede pandoc >= 2.17 (per List:walk sui blocchi del documento).

local function meta_number(value, default)
    if value == nil then
        return default
    end
    local n = tonumber(pandoc.utils.stringify(value))
    return n or default
end

function Pandoc(doc)
    local exe_n = meta_number(doc.meta["exe-start"], 1)
    local exepro_n = meta_number(doc.meta["exepro-start"], 1)

    local function Div(el)
        if el.classes:includes("exefatti") then
            el.content:insert(1, pandoc.Para({ pandoc.Strong({ pandoc.Str("Esercizio " .. exe_n) }) }))
            exe_n = exe_n + 1
        elseif el.classes:includes("exepro") then
            el.content:insert(1, pandoc.Para({ pandoc.Strong({ pandoc.Str("Esercizio proposto " .. exepro_n) }) }))
            exepro_n = exepro_n + 1
        end
        return el
    end

    doc.blocks = doc.blocks:walk({ Div = Div })
    return doc
end
