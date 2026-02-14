-- keys.lua: configurações de atalhos de teclado não relacionados a plugins.
-- Inclui alguns recursos de qualidade de vida que tornam tudo mais agradável

vim.g.mapleader = " "
vim.g.maplocalleader = ","

local u = require("eduardo.lib.utils")
local term = require("eduardo.lib.terminal")
local claw = require("eduardo.lib.clawline")

-- Básicos ---------------------------------------------------------------------

local replace_str = ":s/<c-r><c-w>//g<left><left>"

vim.keymap.set("n", "Q", function() vim.print("Guaraná!") end, { desc = "taunt" })

vim.keymap.set("n", "H"      , "^"      )
vim.keymap.set("n", "L"      , "$"      )
vim.keymap.set("n", "<tab>"  , "gt"     )
vim.keymap.set("n", "<s-tab>", "gT"     )
vim.keymap.set("n", "<bs>"   , "<c-^>zz")
vim.keymap.set("n", "<c-u>"  , "<c-u>zz")
vim.keymap.set("n", "<c-d>"  , "<c-d>zz")

vim.keymap.set("n", "<leader>*"   , u.padline, { desc = "padline"         })
vim.keymap.set("n", "<leader><bs>", u.trim_ws, { desc = "trim_whitespace" })
vim.keymap.set("n", "<leader>P"   , u.toggle_present_mode, { desc = "toggle_present_mode" })

vim.keymap.set("n", "<leader>s", ":%s/"        , { desc = "replace"           })
vim.keymap.set("n", "<leader>/", ":grep "      , { desc = "grep"              })
vim.keymap.set("n", "<leader>e", ":e %:h/"     , { desc = "current_dir_edit"  })
vim.keymap.set("n", "<leader>c", replace_str   , { desc = "replace_word_line" })
vim.keymap.set("n", "<leader>w", vim.cmd.write , { desc = "write"             })
vim.keymap.set("n", "<leader>n", vim.cmd.tabnew, { desc = "tabnew"            })

-- Cópia e cola ----------------------------------------------------------------

vim.keymap.set("v", "<leader>p" , '"_dP', { desc = "paste_over"            })
vim.keymap.set("v", "<leader>x" , '"_d' , { desc = "delete_to_void"        })
vim.keymap.set("n", "<leader>p" , '"+p' , { desc = "clipboard paste"       })
vim.keymap.set("n", "<leader>y" , '"+y' , { desc = "clipboard yank"        })
vim.keymap.set("n", "<leader>yy", '"+yy', { desc = "clipboard yank_line"   })
vim.keymap.set("n", "<leader>Y" , '"+y$', { desc = "clipboard yank_to_eol" })
vim.keymap.set("v", "<leader>y" , '"+y' , { desc = "clipboard yank_visual" })

-- Navegação entre janelas -----------------------------------------------------

vim.keymap.set("n", "<c-k>", "<c-w>k")
vim.keymap.set("n", "<c-j>", "<c-w>j")
vim.keymap.set("n", "<c-h>", "<c-w>h")
vim.keymap.set("n", "<c-l>", "<c-w>l")
vim.keymap.set("i", "<c-k>", "<esc><c-w>k")
vim.keymap.set("i", "<c-j>", "<esc><c-w>j")
vim.keymap.set("i", "<c-h>", "<esc><c-w>h")
vim.keymap.set("i", "<c-l>", "<esc><c-w>l")
vim.keymap.set("t", "<c-k>", term.esc .. "<c-w>k")
vim.keymap.set("t", "<c-j>", term.esc .. "<c-w>j")
vim.keymap.set("t", "<c-h>", term.esc .. "<c-w>h")
vim.keymap.set("t", "<c-l>", term.esc .. "<c-w>l")

-- Terminal --------------------------------------------------------------------

local term_tab_str = "<cmd>tabnew|terminal<cr>"
local repeat_cmd = function() term.send "!!" end

vim.keymap.set("t", "<esc>", term.esc)
vim.keymap.set("t", "<a-l>", "<c-l>")
vim.keymap.set("t", "<a-k>", "<c-k>")

vim.keymap.set("n", "<leader>T", term_tab_str, { desc = "terminal tabnew" })
vim.keymap.set("n", "<leader>t", term.open   , { desc = "terminal open"   })
vim.keymap.set("n", "<leader>r", repeat_cmd  , { desc = "terminal repeat" })

-- Clawline --------------------------------------------------------------------

local show_list_desc = "clawline show_list"
local add_desc = "clawline add_current_file"

vim.keymap.set("n", "<leader>U", claw.show_list, { desc = show_list_desc  })
vim.keymap.set("n", "<leader>u", claw.add_current_file, { desc = add_desc })

for i = 1, 9 do
  local lhs = string.format("<leader>%d", i)
  local desc = string.format("clawline goto %d", i)
  vim.keymap.set("n", lhs, function() claw.goto(i) end, { desc = desc })
end
