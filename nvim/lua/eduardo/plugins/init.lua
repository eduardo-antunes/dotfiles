-- plugins/init.lua: instala e configura os plugins que eu uso com vim.pack

local github = function(x) return "https://github.com/" .. x end
local codeberg = function(x) return "https://codeberg.org/" .. x end

vim.pack.add {
  { src = github "eduardo-antunes/accent.nvim"     },
  { src = github "eduardo-antunes/plainline"       },
  { src = github "nvim-mini/mini.nvim"             },
  { src = github "NMAC427/guess-indent.nvim"       },
  { src = github "tpope/vim-fugitive"              },
  { src = github "stevearc/oil.nvim"               },
  { src = github "mason-org/mason.nvim"            },
  { src = github "nvim-treesitter/nvim-treesitter" },
  { src = codeberg "mfussenegger/nvim-dap"         },
  { src = codeberg "mfussenegger/nvim-jdtls"       },
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

if not vim.g.long_path_length then vim.g.long_path_length = 50 end
local function shorten_long_paths(name)
  if #name < vim.g.long_path_length then return name end
  local n = require("eduardo.lib.utils").count_substr(name, "/")
  local res = name:gsub("([^/])[^/]*/", "%1/", n - 1); return res
end

require("plainline").setup {
  name_filters = { "clean", shorten_long_paths }
}

--------------------------------------------------------------------------------

vim.g.accent_italic_comments = true
vim.g.accent_gray_status = true
vim.g.accent_terminal = true
vim.cmd.colors "accent"

vim.keymap.set("n", "<leader><up>", function()
  vim.g.accent_gray_status = not vim.g.accent_gray_status
  vim.cmd.colors "accent"
end, { desc = "accent toggle_gray" })

vim.keymap.set("n", "<leader><down>", function()
  vim.g.accent_darken = not vim.g.accent_darken
  vim.cmd.colors "accent"
end, { desc = "accent toggle_darken" })

local pick = require("mini.pick")
local function pick_accent_colors()
  local source = {
    name = "Accent Colors",
    choose = function(name)
      vim.g.accent_color = name
      vim.cmd.colors "accent"
    end,
    items = require("accent").accent_colors,
  }
  pick.start { source = source }
end

pick.registry.accent_colors = pick_accent_colors
vim.keymap.set("n", "<leader>C", pick_accent_colors, {
  desc = "accent pick_colors"
})
