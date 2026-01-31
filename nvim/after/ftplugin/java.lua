-- ftplugin/java.lua: configurações para arquivos java

require("eduardo.lib.utils").set_local_term_keys {
  { lhs = "b", cmd = "./gradlew build"  , desc = "java build" },
  { lhs = "r", cmd = "./gradlew bootRun", desc = "java run"   },
  { lhs = "d", cmd = "./gradlew bootRun --debug-jvm", desc = "java debug" },
}
