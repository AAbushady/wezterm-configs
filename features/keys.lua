-- features/keys.lua
-- Remaining keybindings: clipboard, splits, nav, resize, pop-out, swap, close, zoom
local wezterm = require 'wezterm'
local act = wezterm.action
local platform = require 'platform'

local M = {}

local clipboard_mod = platform.is_mac and 'SUPER' or 'CTRL'

local function add_keys(config, keys)
  for _, k in ipairs(keys) do
    table.insert(config.keys, k)
  end
end

function M.setup(config, theme)
  local t_key, t_mod = platform.alt_shift_key('t')
  local s_key, s_mod = platform.alt_shift_key('s')
  local w_key, w_mod = platform.alt_shift_key('w')
  local z_key, z_mod = platform.alt_shift_key('z')

  add_keys(config, {
    -- Smart copy: Cmd+C (macOS) / Ctrl+C (Windows/Linux) — copy if selection, otherwise interrupt
    { key = 'c', mods = clipboard_mod, action = wezterm.action_callback(function(window, pane)
      local sel = window:get_selection_text_for_pane(pane)
      if sel and sel ~= '' then
        window:perform_action(act.CopyTo('Clipboard'), pane)
      else
        window:perform_action(act.SendString('\x03'), pane)
      end
    end) },
    { key = 'v', mods = clipboard_mod, action = act.PasteFrom 'Clipboard' },

    -- Pane splits: Alt+| (side by side), Alt+_ (top/bottom)
    { key = 'phys:Backslash', mods = 'ALT|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'phys:Minus', mods = 'ALT|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

    -- Pop current pane out into its own tab
    { key = t_key, mods = t_mod, action = wezterm.action_callback(function(_, pane)
      pane:move_to_new_tab()
    end) },

    -- Swap pane positions
    { key = s_key, mods = s_mod, action = act.PaneSelect { mode = 'SwapWithActive' } },

    -- Close just the current pane (not the whole tab)
    { key = w_key, mods = w_mod, action = act.CloseCurrentPane { confirm = true } },

    -- Zoom pane to full tab (toggle)
    { key = z_key, mods = z_mod, action = act.TogglePaneZoomState },

    -- Navigate panes with Alt+Arrow
    { key = 'LeftArrow',  mods = 'ALT', action = act.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Right' },
    { key = 'UpArrow',    mods = 'ALT', action = act.ActivatePaneDirection 'Up' },
    { key = 'DownArrow',  mods = 'ALT', action = act.ActivatePaneDirection 'Down' },

    -- Resize panes with Alt+Shift+Arrow
    { key = 'LeftArrow',  mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Left', 3 } },
    { key = 'RightArrow', mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Right', 3 } },
    { key = 'UpArrow',    mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Up', 3 } },
    { key = 'DownArrow',  mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Down', 3 } },
  })
end

return M
