# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A modular, cross-platform WezTerm terminal configuration with multiple themes (Default CGA/VGA, Catppuccin Mocha, One Dark Pro). The config manages appearance, SSH domains, pane/tab management, workspace layouts, and keybindings. Platform-specific behavior (shell, backdrop, clipboard keys, Alt compose) is handled by `platform.lua`.

## Key Files

- `wezterm.lua` — root orchestrator (Lua); WezTerm hot-reloads on save
- `theme.lua` — **gitignored** theme selection (returns a theme name string); see `theme.example.lua`
- `themes/default/init.lua` — Default theme data (classic CGA/VGA palette)
- `themes/catppuccin-mocha/init.lua` — Catppuccin Mocha theme data (alternative)
- `themes/one-dark-pro/init.lua` — One Dark Pro theme data (alternative)
- `features/tab-bar.lua` — `format-tab-title`, `update-status` events, tab bar config
- `hosts.lua` — **gitignored** SSH host definitions (name, address, username, color); see `hosts.example.lua`
- `platform.lua` — cross-platform helpers (OS detection, keybinding adapters)
- `features/ssh.lua` — loads `hosts.lua`, builds `ssh_domains` + `domain_colors`, SSH launcher (`Alt+S`)
- `features/workspaces.lua` — workspace layout picker (`pick-workspace-layout` event, `Alt+Shift+L`)
- `features/merge-tab.lua` — merge-tab helper, `merge-tab-right`/`merge-tab-bottom` events
- `features/keys.lua` — remaining keybindings (clipboard, splits, nav, resize, pop-out, swap, close, zoom)
- `keybindings.md` — cheat sheet of all keybindings; **must be updated** whenever keybindings are added, changed, or removed
- `ssh-terminal-fixes.md` — documents SSH terminal issues (ConPTY bypass, paste, prompt) and their fixes

## Architecture

### Module pattern

Each feature module in `features/` exports a `setup(config, theme)` function that:
- Registers any `wezterm.on(...)` events it owns
- Appends its keybindings to `config.keys`
- Sets any `config.*` values it owns

Root `wezterm.lua` initializes `config.keys = {}`, requires each feature, and calls `setup(config, theme)`.

### wezterm.lua (root orchestrator)

1. **Platform & Appearance** — platform detection via `platform.lua`, shell/backdrop per OS, font, colors, background image/gradient, window settings (all from theme)
2. **Background image detection** — master image → theme image → gradient fallback
3. **Misc settings** — scrollback, spawn tabs, newlines, initial size
4. **Feature setup** — requires and calls `setup()` on each feature module in order

### Feature modules

- **`features/tab-bar.lua`** — tab bar styling, `format-tab-title` (custom tab titles showing process@host), `update-status` (dynamic pane border colors + zoom indicator via config overrides + ANSI color overrides for SSH readability)
- **`features/ssh.lua`** — loads hosts from `hosts.lua`, builds `ssh_domains` and populates `theme.domain_colors`, launcher InputSelector
- **`features/workspaces.lua`** — workspace layout picker; auto-generates "Local | &lt;host&gt;" layouts from `hosts.lua`, `pick-workspace-layout` event drives an InputSelector for multi-pane setups (local + SSH in same tab)
- **`features/merge-tab.lua`** — pull a tab into the current tab as a split pane
- **`features/keys.lua`** — all remaining keybindings not owned by other feature modules

## SSH Domains

Defined in `hosts.lua` (gitignored). Copy `hosts.example.lua` to `hosts.lua` and fill in your hosts. Each entry has `name`, `remote_address`, `username`, and `color` (hex for pane borders/tab accents).

Connect via: `Alt+S` → select host. All domains use `multiplexing = 'None'`. Session persistence is handled by tmux on the remote.

## Conventions

- **Color palette:** Each theme defines its own palette. The Default theme uses CGA/VGA hex values, Catppuccin Mocha uses its palette, One Dark Pro uses its palette.
- **ANSI overrides:** `update-status` overrides ANSI colors with theme-specific lighter variants for better contrast over white text in SSH sessions (e.g., tmux status bars).
- **Domain awareness:** Tab titles, pane borders, and workspace layouts all key off `theme.domain_colors`. To add a new SSH domain, just add an entry to `hosts.lua` — `features/ssh.lua` builds `ssh_domains` and populates `theme.domain_colors` automatically.
- **Keybinding scheme:** `Alt+<key>` for navigation, `Alt+Shift+<key>` for actions (split, merge, close, resize, swap, zoom, layouts). `Cmd+C/V` (macOS) or `Ctrl+C/V` (Windows/Linux) for clipboard.
- **Smart copy:** copies if there's a selection, sends interrupt otherwise.
- **Workspace layouts:** `pane:split` with `DomainName` for cross-domain layouts (local + SSH in same tab). All SSH domains use `multiplexing = 'None'` which supports cross-domain splits.
- **Domain naming:** `ssh_domains` use bare names for `SpawnTab` and `pane:split`. `pane:get_domain_name()` returns prefixed names (e.g. `SSH:myserver`). `domain_colors` uses prefixed keys to match.

## Testing Changes

WezTerm hot-reloads `wezterm.lua` on save. If there's a Lua error, WezTerm shows a red banner at the top of the window with the error message. There is no separate build/lint/test step.
