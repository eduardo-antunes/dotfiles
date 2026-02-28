-- ftplugin/java.lua: configurações para arquivos java

local has_pairs, pairs = pcall(require, "mini.pairs")
if has_pairs then
  pairs.map_buf(0, "i", ">", { action = "close", pair = "<>" })
end

require("eduardo.lib.utils").set_local_term_keys {
  { lhs = "b", cmd = "./gradlew build", desc = "java build" },
  { lhs = "r", cmd = "./gradlew bootRun", desc = "java run"   },
  { lhs = "d", cmd = "./gradlew bootRun --debug-jvm", desc = "java debug" },
}
