-- features/workspaces.lua
-- Workspace layout picker — auto-generates "Local | <host>" from hosts.lua
local wezterm = require 'wezterm'
local act = wezterm.action
local platform = require 'platform'

local M = {}

local ok, hosts = pcall(require, 'hosts')
if not ok then hosts = {} end

local function add_keys(config, keys)
  for _, k in ipairs(keys) do
    table.insert(config.keys, k)
  end
end

function M.setup(config, theme)
  local workspace_layouts = {}
  for _, host in ipairs(hosts) do
    table.insert(workspace_layouts, {
      label = 'Local | ' .. host.name,
      build = function(pane)
        pane:split { direction = 'Right', domain = { DomainName = host.name } }
      end,
    })
  end

  wezterm.on('pick-workspace-layout', function(window, pane)
    if #workspace_layouts == 0 then return end
    local choices = {}
    for i, layout in ipairs(workspace_layouts) do
      table.insert(choices, { label = layout.label, id = tostring(i) })
    end
    window:perform_action(act.InputSelector {
      title = 'Pick workspace layout',
      choices = choices,
      action = wezterm.action_callback(function(_, _, id)
        if not id then return end
        workspace_layouts[tonumber(id)].build(pane)
      end),
    }, pane)
  end)

  local l_key, l_mod = platform.alt_shift_key('l')

  add_keys(config, {
    { key = l_key, mods = l_mod, action = act.EmitEvent('pick-workspace-layout') },
  })
end

return M
