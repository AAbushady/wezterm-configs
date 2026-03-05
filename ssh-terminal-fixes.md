# SSH Terminal Fixes

## Problems

1. **Text swallowed when editing long commands** — Arrowing into the middle of a wrapped command (e.g. long rsync paths) would corrupt the displayed text. This affected both local PowerShell and SSH sessions.
2. **Scroll wheel scrolls command history instead of scrollback** — In tmux over SSH, the mouse wheel sends up/down arrows instead of scrolling the terminal buffer.

## Root Causes

- **Problem 1 (local):** Windows ConPTY has long-standing bugs with cursor tracking on wrapped lines. Every terminal on Windows (WezTerm, Windows Terminal, Alacritty) uses ConPTY for native shells and hits this.
- **Problem 1 (SSH):** Same ConPTY layer was sitting between WezTerm and the SSH connection.
- **Problem 2:** tmux doesn't enable mouse mode by default, so scroll events get interpreted as arrow keys by the shell.

## Fixes

### WezTerm: SSH Domains (bypasses ConPTY for SSH)

In `~/.config/wezterm/features/ssh.lua`, SSH domains are loaded from `hosts.lua` (gitignored) with `multiplexing = 'None'` so WezTerm's built-in SSH client handles the connection directly instead of going through ConPTY. See `hosts.example.lua` for the format.

Session persistence is handled by tmux on the remote side.

Connect as a new tab in the current window with:

```
wezterm cli spawn --domain-name <name>
```

### WezTerm: PSReadLine upgrade (mitigates ConPTY locally)

Upgraded PSReadLine from 2.3.6 to 2.4.5 which has better ConPTY workarounds for local PowerShell:

```powershell
Install-Module PSReadLine -Force -SkipPublisherCheck
```

### Remote: tmux configuration

```bash
# ~/.tmux.conf
set -g mouse on        # scroll wheel scrolls tmux scrollback instead of command history
set -g escape-time 10  # reduce escape sequence delay (avoids garbling from rapid output)
```

## Known Limitation

Tools with heavy ANSI output (spinners, status lines) inside tmux can occasionally garble the display due to tmux's handling of cursor save/restore escape sequences. `Ctrl+L` redraws the screen; `reset` fully reinitializes if needed.

## Quick Setup Checklist for a New Remote

1. Add the host to `hosts.lua` (see `hosts.example.lua` for format)
2. SSH in and create `~/.tmux.conf` with the settings above
3. Restart tmux for settings to take effect
