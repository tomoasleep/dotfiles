local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.hide_tab_bar_if_only_one_tab = true

config.font_size = 12
config.color_scheme = 'Solarized (light) (terminal.sexy)'

return config
