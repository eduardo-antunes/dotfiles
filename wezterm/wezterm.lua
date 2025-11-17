-- Configuração do wezterm, um terminal multiplataforma rico em
-- funcionalidades. Atualmente é a única aplicação cotidiana pra mim que eu
-- utilizo no windows fora do WSL

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Algumas configurações precisam ser ajustadas no windows
local on_windows = wezterm.target_triple:find("windows")

config.default_cwd = wezterm.home_dir
if on_windows then config.default_domain = "WSL:Ubuntu-24.04" end

-- Aparência -------------------------------------------------------------------

config.tab_max_width = 64
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.window_padding = { left = 2, right = 2, top = 0, bottom = 0 }

config.font = wezterm.font "Hack"
config.line_height = on_windows and 1.1 or 1.05
config.font_size = on_windows and 14 or 10

config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"

config.color_schemes = {
  ["starlight"] = require("colors.starlight")
}
config.color_scheme = "starlight"

-- Atalhos de teclado ----------------------------------------------------------

config.keys = {
  { key = "F11", action = wezterm.action.ToggleFullScreen },
}

return config
