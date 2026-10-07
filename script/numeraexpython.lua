-- numera_esercizi.lua
--
-- (commento iniziale invariato)
--
-- Controllo del codice Python: se la variabile d'ambiente HIDE_PYTHON vale "1",
-- i blocchi di codice ```python vengono rimossi dal documento.
-- Le righe che iniziano con "[file]" vengono sempre rimosse.

local function meta_number(value, default)
    if value == nil then
        return default
    end
    local n = tonumber(pandoc.utils.stringify(value))
    return n or default
end

local hide_python = os.getenv("HIDE_PYTHON") == "1"

-- Rimuove la riga iniziale "[file] ..." di un paragrafo (equivalente di sed '/^\[file\]/d')
local function is_file_link(inl)
    return inl.t == "Link" and pandoc.utils.stringify(inl.content) == "file"
end

local function strip_file_line(el)
    if el.content[1] and is_file_link(el.content[1]) then
        local i = 1
        while el.content[i]
            and el.content[i].t ~= "SoftBreak"
            and el.content[i].t ~= "LineBreak" do
            i = i + 1
        end
        if not el.content[i] then
            return {}              -- il paragrafo era solo il link [file]
        end
        for _ = 1, i do
            el.content:remove(1)
        end
        return el
    end
end

function Pandoc(doc)
    local exe_n = meta_number(doc.meta["exe-start"], 1)
    local exepro_n = meta_number(doc.meta["exepro-start"], 1)

    local function Div(el)
        if el.classes:includes("exefatti") then
            el.content:insert(1, pandoc.Para({ pandoc.Strong({ pandoc.Str("Exercise " .. exe_n) }) }))
            exe_n = exe_n + 1
        elseif el.classes:includes("exepro") then
            el.content:insert(1, pandoc.Para({ pandoc.Strong({ pandoc.Str("Proposed exercise " .. exepro_n) }) }))
            exepro_n = exepro_n + 1
        end
        return el
    end

    local function CodeBlock(el)
        if hide_python and el.classes:includes("python") then
            return {}
        end
    end

    doc.blocks = doc.blocks:walk({
        Div = Div,
        CodeBlock = CodeBlock,
        Para = strip_file_line,
        Plain = strip_file_line,
    })
    return doc
end
