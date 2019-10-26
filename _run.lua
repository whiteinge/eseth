--- Pandoc Lua filter to embed inline shell scripts
---
--- Example:
---
---     Directory listing:
---
---     ``` {.run}
---     #!/bin/sh
---     ls -d * | awk '{ print "- [$0]($0)" }'
---     ```

local List = require 'pandoc.List'

function CodeBlock(cb)
    if cb.classes:includes'run' then
        local blocks = List:new()
        local tmpName = os.tmpname()
        local tmpFile = io.open(tmpName, 'w')
        for line in cb.text:gmatch('[^\n]+') do
            if line:sub(1,1)~='#' then
                tmpFile:write(line ..'\n')
            end
        end

        tmpFile:close()
        os.execute('chmod +x '.. tmpName)

        local fh = io.popen(tmpName, 'r')
        blocks:extend(pandoc.read (fh:read '*a').blocks)
        local output = fh:read('*all')
        fh:close()

        os.remove(tmpName)

        return blocks
    end
end
