-- themes/default/init.lua
-- Default (CGA/VGA) theme data for WezTerm
return {
  color_scheme = 'Vs Code Dark+ (Gogh)',
  colors = {
    foreground = '#C0C0C0',
    background = '#000000',
    cursor_bg = '#FFFFFF',
    cursor_fg = '#000000',
    cursor_border = '#FFFFFF',
    ansi = {
      '#000000',  -- black
      '#800000',  -- red
      '#008000',  -- green
      '#808000',  -- yellow
      '#000080',  -- blue
      '#800080',  -- magenta
      '#008080',  -- cyan
      '#C0C0C0',  -- white
    },
    brights = {
      '#808080',  -- bright black
      '#FF0000',  -- bright red
      '#00FF00',  -- bright green
      '#FFFF00',  -- bright yellow
      '#0000FF',  -- bright blue
      '#FF00FF',  -- bright magenta
      '#00FFFF',  -- bright cyan
      '#FFFFFF',  -- bright white
    },
  },
  base = '#000000',
  window = { padding = 12, opacity = 0.95, backdrop = 'Acrylic' },
  cursor = { style = 'BlinkingBar', blink_rate = 500 },
  inactive_pane_hsb = { saturation = 0.75, brightness = 0.55 },
  bg_image = { path = 'themes/default/background', opacity = 0.2 },
  gradient_bg = {
    orientation = { Linear = { angle = -45.0 } },
    colors = { '#000000', '#050508', '#0a0a10' },
  },
  tab_bar = {
    background = '#000000',
    active_tab = { bg_color = '#1a1a1a', fg_color = '#C0C0C0' },
    inactive_tab = { bg_color = '#0d0d0d', fg_color = '#808080' },
    inactive_tab_hover = { bg_color = '#1a1a1a', fg_color = '#C0C0C0' },
  },
  domain_colors = {},  -- populated at runtime from hosts.lua by features/ssh.lua
  default_split_color = '#008080',  -- cyan
  status_colors = { accent = '#00FFFF', muted = '#808080' },
  -- Default dim CGA colors for SSH ANSI overrides (readable on both dark and light backgrounds)
  ansi = {
    '#000000',  -- black
    '#800000',  -- red
    '#008000',  -- green
    '#808000',  -- yellow
    '#000080',  -- blue
    '#800080',  -- magenta
    '#008080',  -- cyan
    '#C0C0C0',  -- white
  },
  brights = {
    '#808080',  -- bright black
    '#FF0000',  -- bright red
    '#00FF00',  -- bright green
    '#FFFF00',  -- bright yellow
    '#0000FF',  -- bright blue
    '#FF00FF',  -- bright magenta
    '#00FFFF',  -- bright cyan
    '#FFFFFF',  -- bright white
  },
}
