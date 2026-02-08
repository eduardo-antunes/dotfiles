-- ftplugin/c.lua: configurações para arquivos C

local u = require("eduardo.lib.utils")

-- Vai do header para a implementação e vice-versa
local function goto_sibling()
  local name = vim.fn.expand "%"
  local ext = vim.fn.expand "%:e"
  if ext == "h" then
    u.edit_tr(name, {{ "%.h", "%.c" }, { "include/", "src/", n = 1 }})
  elseif ext == "c" then
    u.edit_tr(name, {{ "%.c", "%.h" }, { "src/", "include/", n = 1 }})
  end
end

u.set_local_keys {
  { lhs = "<tab>", rhs = goto_sibling, desc = "c goto_sibling" }
}
