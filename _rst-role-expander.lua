-- file: rst-role-expander.lua

-- Macro substitutions: contains macro identifier as
-- keys and the expanded inlines as values.
local macro_substs = {
  ['{{hello}}'] = pandoc.Emph{pandoc.Str "Hello, World!"}
}

-- Replace string with macro expansion, if any.
function Str (s)
  return macro_substs[s.text] or s
end
