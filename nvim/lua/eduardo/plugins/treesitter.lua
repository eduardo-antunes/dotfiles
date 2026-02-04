-- plugins/treesitter.lua: configura o plugin nvim-treesitter

local langs = { "c", "cpp", "rust", "zig", "lua", "python", "go", "vimdoc",
  "markdown", "java", "javascript", "typescript", "comment", "javadoc",
  "printf", "html", "css" }

local treesit_gr = vim.api.nvim_create_augroup("treesit-group", {})
vim.api.nvim_create_autocmd("FileType", {
  group = treesit_gr, pattern = langs, callback = function()
    vim.treesitter.start()
  end
})

vim.api.nvim_create_autocmd("PackChanged", {
  group = treesit_gr, callback = function(ev)
    if ev.name == "nvim-treesitter" then
      require("nvim-treesitter").install(langs)
      require("nvim-treesitter").update()
    end
  end
})
