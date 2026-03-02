-- features/tab-bar.lua
-- Tab bar config, format-tab-title, update-status (domain colors + zoom indicator)
local wezterm = require 'wezterm'

local M = {}

function M.setup(config, theme)
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = true
  config.hide_tab_bar_if_only_one_tab = true

  local domain_colors = theme.domain_colors
  local default_split_color = theme.default_split_color

  -- Custom tab titles: process + dir, colored by domain
  wezterm.on('format-tab-title', function(tab)
    local pane = tab.active_pane
    local process = pane.foreground_process_name or ''
    process = process:gsub('.*[/\\]', '')
    process = process:gsub('%.exe$', '')

    local domain = pane.domain_name or ''
    local color = domain_colors[domain] or default_split_color

    local cwd = pane.current_working_dir
    local dir = ''
    if cwd then
      dir = cwd.file_path or tostring(cwd)
      dir = dir:gsub('[/\\]$', ''):gsub('.*[/\\]', '')
    end

    local title = process
    if domain_colors[domain] then
      local host = domain:gsub('SSHMUX:', ''):gsub('SSH:', '')
      title = host
      if process ~= '' then title = process .. '@' .. host end
    end
    if dir ~= '' then title = title .. ' ' .. dir end
    if title == '' then title = pane.title or 'tab' end

    return wezterm.format({
      { Foreground = { Color = color } },
      { Text = ' ' .. title .. ' ' },
    })
  end)

  wezterm.on('update-status', function(window, pane)
    local color = domain_colors[pane:get_domain_name()] or default_split_color
    local tab = pane:tab()
    if not tab then return end
    local panes_info = tab:panes_with_info()
    local is_zoomed = false
    for _, p in ipairs(panes_info) do
      if p.is_zoomed then is_zoomed = true; break end
    end

    local overrides = {
      hide_tab_bar_if_only_one_tab = not is_zoomed,
      colors = {
        split = color,
        tab_bar = theme.tab_bar,
        ansi = theme.ansi,
        brights = theme.brights,
      },
    }
    window:set_config_overrides(overrides)

    if is_zoomed then
      local hidden = {}
      for _, p in ipairs(panes_info) do
        if p.pane:pane_id() ~= pane:pane_id() then
          local proc = p.pane:get_foreground_process_name() or ''
          proc = proc:gsub('.*[/\\]', ''):gsub('%.exe$', '')
          local d = p.pane:get_domain_name() or ''
          if domain_colors[d] then
            proc = d:gsub('SSHMUX:', ''):gsub('SSH:', '')
          end
          if proc ~= '' then table.insert(hidden, proc) end
        end
      end
      local status = {}
      table.insert(status, { Foreground = { Color = theme.status_colors.accent } })
      table.insert(status, { Text = ' HIDDEN ' })
      if #hidden > 0 then
        table.insert(status, { Foreground = { Color = theme.status_colors.muted } })
        table.insert(status, { Text = '| ' .. table.concat(hidden, ', ') .. ' ' })
      end
      window:set_right_status(wezterm.format(status))
    else
      window:set_right_status('')
    end
  end)
end

return M
