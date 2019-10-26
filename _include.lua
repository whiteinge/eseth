--- Pandoc Lua filter to execute shell scripts
---
--- https://gist.github.com/tarleb/1a690d38508d99c88c331f63ce7f6a2c
---
--- Example:
---
---     ``` {.include}
---     ./foo.sh
---     ./bar.py
---     ```

local List = require 'pandoc.List'

function CodeBlock(cb)
  if cb.classes:includes'include' then
    local blocks = List:new()
    for line in cb.text:gmatch('[^\n]+') do
      if line:sub(1,1)~='#' then
        local fh = assert(io.popen(line, 'r'))
        blocks:extend(pandoc.read (fh:read '*a').blocks)
        local output = fh:read('*all')
        fh:close()
      end
    end
    return blocks
  end
end
