-- utils.lua: pequenas funções utilitárias. Esse é um arquivo que vive sumindo
-- e reaparecendo na minha configuração, mas agora tem uma lógica
-- substancialmente grande para permanecer (eu acho)

local M = {}

-- Calcula o tamanho do maior prefixo comum em uma lista de strings, ignorando
-- quaisquer strings vazias na entrada. O algoritmo é baseado no código da
-- função os.path.commonprefix do python
function M.common_prefix_len(words)
  if not words or #words == 0 then
    return 0
  end
  local min = words[1]
  local max = words[1]
  for i = 2, #words do
    if #words[i] ~= 0 then
      if words[i] < min then min = words[i] end
      if words[i] > max then max = words[i] end
    end
  end
  local c = 0
  for i = 1, #min do
    if max:byte(i) ~= min:byte(i) then
      break
    end
    c = c + 1
  end
  return c
end

-- Apaga espaços em branco sobressalentes em um arquivo
function M.trim_ws()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd [[ keeppatterns %s/\s\+$//e ]]
  vim.api.nvim_win_set_cursor(0, pos)
end

-- Preenche linha com '-' até que ela tenha 80 colunas
function M.padline()
  n = 80 - vim.fn.virtcol "$" + 1
  vim.cmd(string.format("normal $%da-", n))
end

-- Configuração pronta para janelas flutuantes e centralizadas
function M.float_win_config()
  local W, H = vim.o.columns, vim.o.lines
  local height = math.floor(0.618 * H)
  local width  = math.floor(0.618 * W)
  return {
    anchor = "NW",
    style = "minimal",
    relative = "editor",
    height = height, width = width,
    row = math.floor(0.5 * (H - height)),
    col = math.floor(0.5 * (W - width)),
  }
end

-- Conta ocorrências de uma substring em uma string
function M.count_substr(str, sub)
  local n = 0
  for i = 1, #str do
    if str:sub(i, i) == sub then
      n = n + 1
    end
  end
  return n
end

-- Às vezes apresento a minha tela com o neovim aberto para discutir código,
-- e algumas opções que tenho ligadas por padrão e me ajudam muito acabam sendo
-- inconvenientes para esse objetivo. Por exemplo, linhas relativas tornam a
-- comunicação ambígua, por mais úteis que sejam no cotidiano
function M.toggle_present_mode()
  vim.g.presentation_mode = not vim.g.presentation_mode

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.g.presentation_mode then
      vim.wo[win].relativenumber = false
      vim.wo[win].signcolumn = "yes"
      goto continue
    end
    vim.wo[win].relativenumber = true
    vim.wo[win].signcolumn = "number"
    ::continue::
  end
end

-- Define atalhos locais no buffer corrente
-- Utilizado por conveniência em arquivos de ftplugin
function M.set_local_keys(specs)
  for _, spec in ipairs(specs) do
    local lhs = string.format("<localleader>%s", spec.lhs)
    vim.keymap.set("n", lhs, spec.rhs, {
      buffer = 0, desc = spec.desc
    })
  end
end

-- Define atalhos locais para comandos de terminal no buffer corrente
-- Utilizado por conveniência em arquivos de ftplugin
function M.set_local_term_keys(specs)
  for _, spec in ipairs(specs) do
    local lhs = string.format("<localleader>%s", spec.lhs)
    local rhs = function()
      require("eduardo.lib.terminal").send(spec.cmd)
    end
    vim.keymap.set("n", lhs, rhs, {
      buffer = 0, desc = spec.desc
    })
  end
end

return M
