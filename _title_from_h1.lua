-- Promote the first level-1 heading in the body to meta.title, so posts can
-- write `# Foo` once instead of repeating themselves in YAML frontmatter.

local title

function Header (h)
    if not title and h.level == 1 then
        title = h.content
    end
    return h
end

function Meta (meta)
    if title and not meta.title then meta.title = title end
    return meta
end

return {
    {Header = Header},
    {Meta = Meta},
}
