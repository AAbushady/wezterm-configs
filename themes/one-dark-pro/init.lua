-- themes/one-dark-pro/init.lua
-- One Dark Pro theme data for WezTerm
return {
  color_scheme = 'OneDark (Gogh)',
  colors = { foreground = '#c8ccd4' },
  base = '#282c34',
  window = { padding = 12, opacity = 0.95, backdrop = 'Acrylic' },
  cursor = { style = 'BlinkingBar', blink_rate = 500 },
  inactive_pane_hsb = { saturation = 0.75, brightness = 0.55 },
  bg_image = { path = 'themes/one-dark-pro/background', opacity = 0.2 },
  gradient_bg = {
    orientation = { Linear = { angle = -45.0 } },
    colors = { '#282c34', '#21252b', '#1e2127' },
  },
  tab_bar = {
    background = '#1e2127',
    active_tab = { bg_color = '#282c34', fg_color = '#c8ccd4' },
    inactive_tab = { bg_color = '#21252b', fg_color = '#7f848e' },
    inactive_tab_hover = { bg_color = '#2c313c', fg_color = '#c8ccd4' },
  },
  domain_colors = {},  -- populated at runtime from hosts.lua by features/ssh.lua
  default_split_color = '#61afef',  -- blue
  status_colors = { accent = '#c678dd', muted = '#5c6370' },
  -- One Light (darker) variants for better contrast over white text in SSH sessions
  ansi = {
    '#383a42',  -- black
    '#e45649',  -- red
    '#50a14f',  -- green
    '#c18401',  -- yellow
    '#4078f2',  -- blue
    '#a626a4',  -- magenta
    '#0184bc',  -- cyan
    '#abb2bf',  -- white
  },
  brights = {
    '#4f525e',  -- bright black
    '#e45649',  -- bright red
    '#50a14f',  -- bright green
    '#c18401',  -- bright yellow
    '#4078f2',  -- bright blue
    '#a626a4',  -- bright magenta
    '#0184bc',  -- bright cyan
    '#828997',  -- bright white
  },
}
