-- platform.lua
-- Cross-platform helpers for keybinding differences
local wezterm = require 'wezterm'

local M = {}

M.is_windows = wezterm.target_triple:find('windows') ~= nil
M.is_mac = wezterm.target_triple:find('apple') ~= nil

-- On macOS with composed keys disabled, ALT|SHIFT+<letter> arrives as ALT+<UPPER>.
-- Returns key, mods that work on all platforms.
function M.alt_shift_key(key)
  if M.is_mac then
    return key:upper(), 'ALT'
  else
    return key, 'ALT|SHIFT'
  end
end

return M
