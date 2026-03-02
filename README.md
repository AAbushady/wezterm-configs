# WezTerm Config

Cross-platform modular WezTerm configuration with multiple themes.

## Themes

Three themes are included:

- **Default** — classic CGA/VGA 16-color palette (black background, silver foreground)
- **Catppuccin Mocha** — pastel palette on a dark base
- **One Dark Pro** — Atom-inspired dark theme

To switch themes, copy `theme.example.lua` to `theme.lua` and set your preferred theme name:

```lua
return 'one-dark-pro'
```

Without `theme.lua`, the Default theme is used. The file is gitignored — your choice stays local.

## Install

**Linux / macOS:**

```bash
git clone https://github.com/AAbushady/wezterm-configs.git ~/.config/wezterm
```

**Windows (PowerShell):**

```powershell
git clone https://github.com/AAbushady/wezterm-configs.git "$HOME\.config\wezterm"
```

**Windows (CMD):**

```cmd
git clone https://github.com/AAbushady/wezterm-configs.git "%USERPROFILE%\.config\wezterm"
```

**Theme (optional):** Copy `theme.example.lua` to `theme.lua` and set your preferred theme. Without it, defaults to Default (CGA/VGA).

**Font (optional):** Copy `font.example.lua` to `font.lua` and set your preferred font. Without it, defaults to JetBrains Mono.

**SSH hosts (optional):** Copy `hosts.example.lua` to `hosts.lua` and fill in your hosts.

All three files are gitignored — customize without affecting the repo.

## Keybindings

See [keybindings.md](keybindings.md) for the full cheat sheet. Quick summary:

- `Alt+Arrow` — navigate panes
- `Alt+|` / `Alt+_` — split panes
- `Alt+S` — SSH launcher
- `Alt+Shift+L` — workspace layouts

On macOS, `Alt` = `Opt` and clipboard shortcuts use `Cmd` instead of `Ctrl`.

## Structure

```
wezterm.lua              root orchestrator
platform.lua             cross-platform helpers
themes/
  default/               default theme (CGA/VGA)
  catppuccin-mocha/      alternative theme
  one-dark-pro/          alternative theme
features/
  keys.lua               clipboard, splits, nav, resize
  tab-bar.lua            tab titles, pane border colors
  ssh.lua                SSH domains + launcher
  workspaces.lua         workspace layout picker
  merge-tab.lua          pull tabs into splits
theme.lua                your theme choice (gitignored)
theme.example.lua        template for theme.lua
font.lua                 your font settings (gitignored)
font.example.lua         template for font.lua
hosts.lua                your SSH hosts (gitignored)
hosts.example.lua        template for hosts.lua
```
