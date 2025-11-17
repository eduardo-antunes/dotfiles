-- plugins/mini.lua: configura os vários pequenos plugins compreendidos
-- pela biblioteca mini.nvim. É uma coleção extremamente útil

-- Equilibra delimitadores automaticamente, o que para mim é realmente
-- uma necessidade básica. Similar ao electric-pair do emacs
require("mini.pairs").setup()

-- Oferece operações extras sobre delimitadores. É portanto similar ao
-- vim-surround do tpope, embora não seja "retrocompatível" com ele (os
-- atalhos são diferentes, mas são também lógicos)
require("mini.surround").setup()

-- Atalhos para movimentar seleções arbitrárias de texto por um arquivo;
-- substitui alguns dos meus atalhos mais úteis e confusos
require("mini.move").setup {
  mappings = {
    -- Os atalhos padrão entram em conflito com o tmux
    left = "<c-H>", right = "<c-L>", down = "<c-J>", up = "<c-K>",
    line_left = "<c-H>", line_right = "<c-L>",
    line_down = "<c-J>", line_up = "<c-K>"
  }
}

-- Atalhos e funções para alinhar texto verticalmente. Eu adoro fazer
-- isso, e me deixa bem satisfeito que não dê mais trabalho
require("mini.align").setup()

-- Atalhos e funções para dividir listas em linhas e juntá-las novamente
-- Honestamente, um dos módulos mais específicos e úteis aqui
require("mini.splitjoin").setup()

-- Expande o sistema de preenchimento ("completion") nativo do vim,
-- tornando-o automático e integrando com LSP. Muito leve e simples
-- quando comparado a alternativas como o nvim-cmp, e já me atende bem
require("mini.completion").setup()

-- Funcionalidade extra para outros plugins do mini.nvim
require("mini.extra").setup()
