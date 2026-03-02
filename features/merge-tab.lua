-- features/merge-tab.lua
-- Pull another tab into the current tab as a split pane
local wezterm = require 'wezterm'
local act = wezterm.action
local platform = require 'platform'

local M = {}

-- Full path to wezterm CLI (bare 'wezterm' may not be on PATH on macOS)
local wezterm_bin = wezterm.executable_dir .. '/wezterm'

local function add_keys(config, keys)
  for _, k in ipairs(keys) do
    table.insert(config.keys, k)
  end
end

function M.setup(config, theme)
  local function merge_tab(window, pane, direction)
    local current_tab_id = pane:tab():tab_id()
    local choices = {}

    for _, tab in ipairs(window:mux_window():tabs()) do
      if tab:tab_id() ~= current_tab_id then
        local tab_panes = tab:panes()
        local active_pane = tab:active_pane()
        local process = active_pane:get_foreground_process_name() or ''
        process = process:gsub('.*[/\\]', '')
        local cwd = active_pane:get_current_working_dir()
        local dir = ''
        if cwd then
          dir = cwd.file_path or tostring(cwd)
          dir = dir:gsub('[/\\]$', ''):gsub('.*[/\\]', '')
        end

        local label = process
        if dir ~= '' then label = label .. ' — ' .. dir end
        if label == '' then label = active_pane:get_title() end
        if label == '' then label = active_pane:get_domain_name() end
        if label == '' then label = 'Tab ' .. tab:tab_id() end
        if #tab_panes > 1 then label = label .. ' (' .. #tab_panes .. ' panes)' end

        table.insert(choices, {
          label = label,
          id = tostring(tab_panes[1]:pane_id()),
        })
      end
    end

    if #choices == 0 then return end

    window:perform_action(act.InputSelector {
      title = 'Merge tab ' .. direction,
      choices = choices,
      action = wezterm.action_callback(function(_, _, id, _)
        if not id then return end
        wezterm.run_child_process({
          wezterm_bin, 'cli', 'split-pane',
          '--pane-id', tostring(pane:pane_id()),
          '--move-pane-id', id,
          '--' .. direction,
        })
      end),
    }, pane)
  end

  wezterm.on('merge-tab-right', function(window, pane) merge_tab(window, pane, 'right') end)
  wezterm.on('merge-tab-bottom', function(window, pane) merge_tab(window, pane, 'bottom') end)

  local m_key, m_mod = platform.alt_shift_key('m')
  local b_key, b_mod = platform.alt_shift_key('b')

  add_keys(config, {
    { key = m_key, mods = m_mod, action = act.EmitEvent('merge-tab-right') },
    { key = b_key, mods = b_mod, action = act.EmitEvent('merge-tab-bottom') },
  })
end

return M
