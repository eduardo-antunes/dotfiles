-- plugins/pick.lua: configura o mini.pick, um seletor genérico, leve e
-- flexível; parte do mini.nvim que eu mais configuro

local pick = require("mini.pick")
local u = require("eduardo.lib.utils")

vim.ui.select = pick.ui_select
pick.setup {
  window = { config = u.float_win_config, prompt_caret = "█ " },
  source = { show = pick.default_show },
}

vim.keymap.set("n", "<c-f>", pick.builtin.files, { desc = "pick files" })
vim.keymap.set("n", "<c-b>", pick.builtin.buffers, { desc = "pick buffers" })
vim.keymap.set("n", "<leader>h", pick.builtin.help, { desc = "pick help" })

--------------------------------------------------------------------------------

-- Pesquisa em arquivos com caminhos truncados; útil principalmente em projetos
-- com estruturas de diretórios profundamente aninhadas, como os típicos em java
local function abbrev_files()
  local original_paths = {}
  local source = {
    name = "Abbrev Files (rg)",
    choose = function(path)
      pick.default_choose(original_paths[path])
    end,
    preview = function(buf, path, opts)
      pick.default_preview(buf, original_paths[path], opts)
    end,
  }
  pick.builtin.cli({
    command = { "rg", "--files" },
    postprocess = function(paths)
      local items = {}
      for _, path in ipairs(paths) do
        if path == "" then break end
        local dir = vim.fn.fnamemodify(path, ":h:t")
        local name = vim.fn.fnamemodify(path, ":t")
        local new_path = (dir ~= ".")
          and string.format("%s/%s", dir, name)
          or name
        table.insert(items, new_path)
        original_paths[new_path] = path
      end
      return items
    end,
  }, { source = source })
end
pick.registry.abbrev_files = abbrev_files
vim.keymap.set("n", "<leader>f", abbrev_files, {
  desc = "pick abbrev_files"
})

-- Pesquisa apenas arquivos sob o diretório atual (caminhos truncados)
local function current_filetree()
  local original_paths = {}
  local source = {
    name = "Current Filetree (rg)",
    choose = function(path)
      pick.default_choose(original_paths[path])
    end,
    preview = function(buf, path, opts)
      pick.default_preview(buf, original_paths[path], opts)
    end,
  }
  local dir = vim.fn.expand("%:h")
  pick.builtin.cli({
    command = { "rg", "--files", dir },
    postprocess = function(paths)
      local items = {}
      local prefix_len = u.common_prefix_len(paths)
      for _, path in ipairs(paths) do
        if path == "" then break end
        local new_path = path:sub(prefix_len + 1)
        original_paths[new_path] = path
        table.insert(items, new_path)
      end
      return items
    end
  }, { source = source })
end
pick.registry.current_filetree = current_filetree
vim.keymap.set("n", "<leader>.", current_filetree, {
  desc = "pick current_filetree"
})

-- Pesquisa todos os arquivos, inclusive os ocultos, com exceção da pasta .git
local function all_files()
  local source = { name = "All Files (rg)" }
  local command = { "rg", "--files", "--hidden", "--glob", "!.git" }
  pick.builtin.cli({ command = command }, { source = source })
end
pick.registry.all_files = all_files
vim.keymap.set("n", "<leader>F", all_files, { desc = "pick all_files" })

-- Pesquisa na lista de arquivos do clawline.lua
local function clawline_files()
  local source = {
    name = "Clawline Pick",
    items = require("eduardo.lib.clawline").clawline_list
  }
  pick.start { source = source }
end
pick.registry.clawline = clawline_files
vim.keymap.set("n", "<leader>i", clawline_files, { desc = "pick clawline" })

--------------------------------------------------------------------------------

local extra = require("mini.extra").pickers
vim.keymap.set("n", "<leader>k", extra.keymaps, { desc = "pick keymaps" })
