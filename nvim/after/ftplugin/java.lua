-- ftplugin/java.lua: configurações específicas para java, com focos em projetos
-- que utilizam gradle e spring boot

local function set(key, cmd, desc)
  local opts = { buffer = 0, desc = desc }
  local lhs = string.format("<localleader>%s", key)
  local rhs = function()
    require("eduardo.lib.terminal").send(cmd)
  end
  vim.keymap.set("n", lhs, rhs, opts)
end

set("b", "./gradlew build", "gradle build")
set("r", "./gradlew bootRun", "gradle build")
set("d", "./gradlew bootRun --debug-jvm", "gradle debug")
