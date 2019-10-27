
--- Pandoc Lua filter to change links to absolute links for RSS

local function starts_with(str, start)
    return str:sub(1, #start) == start
end

function fix_path (path)
    if starts_with(path, './') then
        return (os.getenv('PANDOC_PREFIX') or '') .. path:sub(2)
    elseif starts_with(path, '../') then
        return (os.getenv('PANDOC_PREFIX') or '') .. path:sub(3)
    else
        return path
    end
end

function Link (element)
    element.target = fix_path(element.target)
    return element
end

function Image (element)
    element.src = fix_path(element.src)
    return element
end

