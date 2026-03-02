-- themes/catppuccin-mocha.lua
-- Catppuccin Mocha theme data for WezTerm
return {
  color_scheme = 'Catppuccin Mocha',
  base = '#1e1e2e',
  window = { padding = 12, opacity = 0.95, backdrop = 'Acrylic' },
  cursor = { style = 'BlinkingBar', blink_rate = 500 },
  inactive_pane_hsb = { saturation = 0.75, brightness = 0.55 },
  bg_image = { path = 'themes/catppuccin-mocha/background', opacity = 0.2 },
  gradient_bg = {
    orientation = { Linear = { angle = -45.0 } },
    colors = { '#1e1e2e', '#181825', '#11111b', '#180f25' },
  },
  tab_bar = {
    background = '#11111b',
    active_tab = { bg_color = '#313244', fg_color = '#cdd6f4' },
    inactive_tab = { bg_color = '#181825', fg_color = '#6c7086' },
    inactive_tab_hover = { bg_color = '#45475a', fg_color = '#cdd6f4' },
  },
  domain_colors = {},  -- populated at runtime from hosts.lua by features/ssh.lua
  default_split_color = '#b4befe',  -- lavender
  status_colors = { accent = '#cba6f7', muted = '#6c7086' },
  -- Catppuccin Latte (darker) variants for better contrast over white text in SSH sessions
  ansi = {
    '#45475a',  -- black
    '#d20f39',  -- red
    '#40a02b',  -- green
    '#df8e1d',  -- yellow
    '#1e66f5',  -- blue
    '#8839ef',  -- magenta
    '#179299',  -- cyan
    '#bac2de',  -- white
  },
  brights = {
    '#585b70',  -- bright black
    '#d20f39',  -- bright red
    '#40a02b',  -- bright green
    '#df8e1d',  -- bright yellow
    '#1e66f5',  -- bright blue
    '#8839ef',  -- bright magenta
    '#179299',  -- bright cyan
    '#a6adc8',  -- bright white
  },
}
