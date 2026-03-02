local wezterm = require 'wezterm'
local platform = require 'platform'

-- Theme (from gitignored theme.lua — see theme.example.lua)
package.loaded['theme'] = nil
local ok, theme_name = pcall(require, 'theme')
if not ok or type(theme_name) ~= 'string' then theme_name = 'default' end
local theme = require('themes.' .. theme_name)

local config = {}

local is_windows = platform.is_windows
local is_mac = platform.is_mac

-- Font (from gitignored font.lua — see font.example.lua)
local default_font = { family = 'JetBrains Mono', size = 12, line_height = 1.0 }
package.loaded['font'] = nil
local ok, font = pcall(require, 'font')
if not ok or type(font) ~= 'table' or not font.family then font = default_font end

-- Shell & platform-specific settings
if is_windows then
  config.default_prog = { 'pwsh.exe' }
  config.win32_system_backdrop = theme.window.backdrop
elseif is_mac then
  config.macos_window_background_blur = 20
  config.send_composed_key_when_left_alt_is_pressed = false
  config.send_composed_key_when_right_alt_is_pressed = false
end

-- Appearance (from theme)
config.color_scheme = theme.color_scheme
config.font = wezterm.font(font.family)
config.font_size = font.size
config.line_height = font.line_height
local pad = theme.window.padding
config.window_padding = { left = pad, right = pad, top = pad, bottom = pad }
config.window_background_opacity = theme.window.opacity
if theme.colors then config.colors = theme.colors end

-- Background: master image (background.*) overrides theme image, then gradient fallback.
-- Drop a "background.png" (or .gif for animated!) in your wezterm config folder to override.
local image_exts = { 'gif', 'png', 'jpg', 'jpeg', 'webp' }

local function find_image(base_path)
  for _, ext in ipairs(image_exts) do
    local path = base_path .. '.' .. ext
    local f = io.open(path, 'r')
    if f then f:close(); return path end
  end
end

local bg_image = find_image(wezterm.config_dir .. '/background')
local bg_opacity = 0.2
if not bg_image and theme.bg_image then
  bg_image = find_image(wezterm.config_dir .. '/' .. theme.bg_image.path)
  bg_opacity = theme.bg_image.opacity or 0.2
end

if bg_image then
  config.background = {
    { source = { Color = theme.base }, width = '100%', height = '100%' },
    {
      source = { File = bg_image },
      width = 'Cover',
      height = 'Cover',
      horizontal_align = 'Center',
      vertical_align = 'Middle',
      opacity = bg_opacity,
    },
  }
else
  config.background = {
    {
      source = { Gradient = theme.gradient_bg },
      width = '100%',
      height = '100%',
    },
  }
end

-- Pane focus: dim inactive panes
config.inactive_pane_hsb = theme.inactive_pane_hsb

-- Cursor
config.default_cursor_style = theme.cursor.style
config.cursor_blink_rate = theme.cursor.blink_rate

-- Misc
config.initial_cols = 120
config.initial_rows = 30
config.scrollback_lines = 10000
config.prefer_to_spawn_tabs = true
config.canonicalize_pasted_newlines = 'None'

-- Feature modules append their keybindings and register events
config.keys = {}
require('features.tab-bar').setup(config, theme)
require('features.ssh').setup(config, theme)
require('features.workspaces').setup(config, theme)
require('features.merge-tab').setup(config, theme)
require('features.keys').setup(config, theme)

return config
