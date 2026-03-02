-- features/ssh.lua
-- SSH domain definitions and launcher
local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}

-- Load hosts from gitignored hosts.lua (falls back to empty list)
local ok, hosts = pcall(require, 'hosts')
if not ok then hosts = {} end

local function add_keys(config, keys)
  for _, k in ipairs(keys) do
    table.insert(config.keys, k)
  end
end

function M.setup(config, theme)
  config.ssh_domains = {}
  for _, host in ipairs(hosts) do
    table.insert(config.ssh_domains, {
      name = host.name,
      remote_address = host.remote_address,
      username = host.username,
      multiplexing = 'None',
    })
    if host.color then
      theme.domain_colors['SSH:' .. host.name] = host.color
    end
  end

  add_keys(config, {
    -- Quick SSH launcher: pick a domain, open as a new tab
    { key = 's', mods = 'ALT', action = wezterm.action_callback(function(window, pane)
      if #config.ssh_domains == 0 then return end
      local choices = {}
      for _, domain in ipairs(config.ssh_domains) do
        table.insert(choices, {
          label = domain.name .. '  (' .. domain.username .. '@' .. domain.remote_address .. ')',
          id = domain.name,
        })
      end
      window:perform_action(act.InputSelector {
        title = 'Connect via SSH',
        choices = choices,
        action = wezterm.action_callback(function(win, p, id)
          if not id then return end
          win:perform_action(act.SpawnTab { DomainName = id }, p)
        end),
      }, pane)
    end) },
  })
end

return M
