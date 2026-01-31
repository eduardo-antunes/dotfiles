-- ftplugin/c.lua: configurações para arquivos C

local function goto_impl(name)
  local sib_name = name:gsub("%.h", "%.c")
  sib_name = sib_name:gsub("include/", "src/", 1)
  if vim.fn.filereadable(sib_name) == 0 then return end
  vim.cmd.edit(sib_name)
end

local function goto_header(name)
  local sib_name = name:gsub("%.c", "%.h")
  sib_name = sib_name:gsub("src/", "include/", 1)
  if vim.fn.filereadable(sib_name) == 0 then return end
  vim.cmd.edit(sib_name)
end

-- Vai para o arquivo "irmão" do arquivo atual, i.e. do arquivo .c para o
-- arquivo .h correspondente e vice-versa. Procura pelo arquivo irmão
-- considerando dois arranjos possíveis:
-- * headers e implementações no mesmo diretório
-- * headers em include/ e implementações em src/
local function goto_sibling()
  local name = vim.api.nvim_buf_get_name(0)
  if vim.fn.expand "%:e" == "h" then goto_impl(name)
  else goto_header(name) end
end

require("eduardo.lib.utils").set_local_keys {
  { lhs = "<tab>", rhs = goto_sibling, desc = "c goto_sibling" }
}
