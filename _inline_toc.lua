-- Replace a paragraph containing only "[TOC]" with a nested bullet list of
-- the document's level-2 and level-3 headings. Each entry links to the
-- heading's anchor id (auto-slugged or explicit `{#anchor}`).

local sections = {}

function Header (h)
    if (h.level == 2 or h.level == 3) and h.identifier ~= "" then
        table.insert(sections, {
            level = h.level,
            id = h.identifier,
            inlines = h.content,
        })
    end
    return h
end

local function build_toc ()
    local items = {}
    local last_h2_item = nil
    local last_h2_sublist = nil
    local has_h3 = false

    for _, s in ipairs(sections) do
        local entry = pandoc.Plain({pandoc.Link(s.inlines, "#" .. s.id)})

        if s.level == 2 then
            last_h2_item = {entry}
            last_h2_sublist = nil
            table.insert(items, last_h2_item)
        elseif s.level == 3 and last_h2_item ~= nil then
            has_h3 = true
            if last_h2_sublist == nil then
                last_h2_sublist = pandoc.BulletList({})
                table.insert(last_h2_item, last_h2_sublist)
            end
            table.insert(last_h2_sublist.content, {entry})
        end
    end

    local cls = has_h3 and "toc toc-nested" or "toc toc-flat"
    return pandoc.Div(pandoc.BulletList(items), pandoc.Attr("", {cls}))
end

function Pandoc (doc)
    if #sections == 0 then return nil end

    for i, block in ipairs(doc.blocks) do
        if block.t == "Para"
            and #block.content == 1
            and block.content[1].t == "Str"
            and block.content[1].text == "[TOC]" then
            doc.blocks[i] = build_toc()
            return doc
        end
    end

    return nil
end
