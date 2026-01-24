-- plugins/init.lua: instala e configura os plugins que eu uso com vim.pack

local github = function(x) return "https://github.com/" .. x end

vim.pack.add {
  { src = github "eduardo-antunes/accent.nvim"     },
  { src = github "eduardo-antunes/plainline"       },
  { src = github "nvim-mini/mini.nvim"             },
  { src = github "NMAC427/guess-indent.nvim"       },
  { src = github "tpope/vim-fugitive"              },
  { src = github "stevearc/oil.nvim"               },
  { src = github "mason-org/mason.nvim"            },
  { src = github "nvim-treesitter/nvim-treesitter" },
  { src = github "mfussenegger/nvim-dap"           },
  { src = github "mfussenegger/nvim-jdtls"         },
}

require("eduardo.plugins.treesitter")
require("eduardo.plugins.fugitive")
require("eduardo.plugins.mini")
require("eduardo.plugins.pick")
require("eduardo.plugins.oil")
require("eduardo.plugins.dap")

require("guess-indent").setup()
require("mason").setup {
  ui = {
    icons = {
      package_installed   = "*",
      package_pending     = "*",
      package_uninstalled = "*",
    }
  }
}

local function shorten_java_path(name)
  if vim.bo.filetype ~= "java" then return name end
  local n = require("eduardo.lib.utils").count_substr(name, "/")
  local res = name:gsub("([^/])[^/]*/", "%1/", n - 1); return res
end

require("plainline").setup {
  name_filters = { "clean", shorten_java_path }
}

vim.g.accent_terminal = true
vim.g.accent_gray_status = true
vim.g.accent_italic_comments = true
vim.cmd.colors "accent"

vim.keymap.set("n", "<leader><tab>", function()
  vim.g.accent_gray_status = not vim.g.accent_gray_status
  vim.cmd.colors "accent"
end)
