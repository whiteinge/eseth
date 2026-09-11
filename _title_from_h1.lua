-- Promote the first level-1 heading in the body to meta.title, so posts can
-- write `# Foo` once instead of repeating themselves in YAML frontmatter.
--
-- Also derive meta.canonical, the page's absolute URL, from the output path
-- the Makefile passes in as `outfile` plus site.yml's `root`. The page
-- template uses it for rel=canonical and for schema.org mainEntityOfPage.

local title

function Header (h)
    if not title and h.level == 1 then
        title = h.content
    end
    return h
end

function Meta (meta)
    if title and not meta.title then meta.title = title end

    if meta.outfile and not meta.canonical then
        local root = meta.root and pandoc.utils.stringify(meta.root) or ''
        -- Directory indexes are canonically the bare directory URL, not the
        -- index.html inside it, since that is how the site links to them.
        local path = pandoc.utils.stringify(meta.outfile)
            :gsub('^index%.html$', '')
            :gsub('/index%.html$', '/')
        meta.canonical = root .. '/' .. path
    end

    return meta
end

return {
    {Header = Header},
    {Meta = Meta},
}
