-- ftplugin/rust.lua: configurações para arquivos Rust

local has_pairs, pairs = pcall(require, "mini.pairs")
if has_pairs then
  -- A aspa simples sozinha é útil para denotar lifetimes
  vim.keymap.set("i", "'", "'", { buffer = 0 })
  pairs.map_buf(0, "i", ">", { action = "close", pair = "<>" })
end

require("eduardo.lib.utils").set_local_term_keys {
  { lhs = "b", cmd = "cargo build", desc = "rust build" },
  { lhs = "r", cmd = "cargo run", desc = "rust run" },
}
