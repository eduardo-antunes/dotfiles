-- clawline.lua: minha versão reduzida do plugin harpoon.nvim. Simplesmente
-- mantém uma lista de arquivos para acesso rápido, salvos manualmente. Em
-- outras palavras, são marcas globais sem uma posição. O nome é uma referência
-- a hollow knight silksong. Guaraná!

local M = { clawline_list = {} }

M.group = vim.api.nvim_create_augroup("clawline", {})

function M.add_current_file()
  local cwd = string.format("%s/", vim.uv.cwd())
  local name = vim.api.nvim_buf_get_name(0):gsub(cwd, "")
  for _, existing_name in ipairs(M.clawline_list) do
    if name == existing_name then return end
  end
  table.insert(M.clawline_list, name)
end

function M.goto(n)
  if not M.clawline_list[n] then return end
  vim.cmd.edit(M.clawline_list[n])
end

local function create_clawline_list_buffer()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, "clawline")

  -- Define o conteúdo do buffer
  local lines = {}
  for _, name in ipairs(M.clawline_list) do
    table.insert(lines, name)
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Define os atalhos para o buffer
  vim.keymap.set("n", "<cr>", function()
    local n = vim.api.nvim_win_get_cursor(0)[1]
    local name = vim.api.nvim_buf_get_lines(0, n - 1, n, false)[1]
    if not name or name == "" then return end
    vim.api.nvim_win_close(0, false)
    vim.cmd.edit(name)
  end, { buffer = buf })
  vim.keymap.set("n", "q", "<c-w>q", { buffer = buf })

  return buf
end

local function create_clawline_list_window(buf)
  local conf = require("eduardo.lib.utils").float_win_config()
  conf.footer = " Clawline List "
  local win = vim.api.nvim_open_win(buf, true, conf)
  vim.wo[win].number = true

  vim.api.nvim_create_autocmd("WinClosed", {
    group = M.group, pattern = string.format("%d", win), callback = function()
      -- Atualiza-se a lista de acordo com o conteúdo do buffer
      M.clawline_list = {}
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      for _, name in ipairs(lines) do
        if name == "" then goto continue end
        table.insert(M.clawline_list, name)
        ::continue::
      end
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  })

  -- Define os highlights da janela, para destacar números de linha
  local ns = vim.api.nvim_create_namespace("clawline-ns")
  vim.api.nvim_set_hl(ns, "LineNr", { link = "Special" })
  vim.api.nvim_win_set_hl_ns(win, ns)
end

function M.show_list()
  local list_buf = create_clawline_list_buffer()
  create_clawline_list_window(list_buf)
end

return M
