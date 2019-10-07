local title

-- Set the meta title to the first document heading
-- local msg = '[WARNING] title already set; discarding header "%s"\n'
-- io.stderr:write(msg:format(pandoc.utils.stringify(header)))

function get_first_header (header)
    if not title then
        title = header.content
    end

    return header
end

function set_meta_title (meta)
    meta.title = title
    return meta
end

return {
    {Header = get_first_header},
    {Meta = set_meta_title},
}
