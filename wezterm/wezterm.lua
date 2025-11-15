local wezterm = require "wezterm"
local config = wezterm.config_builder()

local font_size = 10

-- WSL -------------------------------------------------------------------------

if wezterm.target_triple:find "windows" then
  config.default_domain = "WSL:Ubuntu-24.04"
  config.default_cwd = wezterm.home_dir
  -- In Windows, I guess because of rendering distances, the font size needs to
  -- be bigger in order for the font to show the same way
  font_size = 14
end

-- Aparência e fontes ----------------------------------------------------------

config.tab_max_width = 64
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.window_padding = { left = 2, top = 0, bottom = 0, right = 2 }

config.font_size = font_size
config.font = wezterm.font "Hack"
-- With the options below, font rendering looks wonderfully sharp in every OS
config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"

-- Atalhos de teclado ----------------------------------------------------------

config.leader = { key = "a", mods = "CTRL" }
config.keys = {
  { key = "F11", action = wezterm.action.ToggleFullScreen },
  { mods = "LEADER|CTRL", key = "a",
    action = wezterm.action.SendKey { mods = "CTRL", key = "a" },
  },
  { mods = "LEADER", key = "c",
    action = wezterm.action.SpawnTab "CurrentPaneDomain"
  },
  { mods = "LEADER", key = "w",
    action = wezterm.action.CloseCurrentTab { confirm = true }
  },
  { mods = "LEADER", key = "q",
    action = wezterm.action.CloseCurrentPane { confirm = true }
  },
  { mods = "LEADER", key = "v",
    action = wezterm.action.SplitHorizontal {}
  },
  { mods = "LEADER", key = "h",
    action = wezterm.action.SplitVertical {}
  },
  { mods = "LEADER", key = "1",
    action = wezterm.action.ActivateTab(0)
  },
  { mods = "LEADER", key = "2",
    action = wezterm.action.ActivateTab(1)
  },
  { mods = "LEADER", key = "3",
    action = wezterm.action.ActivateTab(2)
  },
  { mods = "LEADER", key = "4",
    action = wezterm.action.ActivateTab(3)
  },
  { mods = "LEADER", key = "5",
    action = wezterm.action.ActivateTab(4)
  },
  { mods = "LEADER", key = "6",
    action = wezterm.action.ActivateTab(5)
  },
  { mods = "LEADER", key = "7",
    action = wezterm.action.ActivateTab(6)
  },
  { mods = "LEADER", key = "8",
    action = wezterm.action.ActivateTab(7)
  },
  { mods = "LEADER", key = "9",
    action = wezterm.action.ActivateTab(8)
  },
}

return config
