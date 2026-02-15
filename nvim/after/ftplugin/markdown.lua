-- ftplugin/markdown.lua: configurações para arquivos markdown

local function code_snippet()
  vim.snippet.expand("```$1\n$0\n```")
end

require("eduardo.lib.utils").set_local_keys {
  { lhs = "c", rhs = code_snippet, desc = "markdown code_snippet" }
}
