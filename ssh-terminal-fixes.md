# SSH Terminal Fixes

## Problems

1. **Text swallowed when editing long commands** — Arrowing into the middle of a wrapped command (e.g. long rsync paths) would corrupt the displayed text. This affected both local PowerShell and SSH sessions.
2. **Paste garbling** — Pasting long commands would display duplicated/truncated text (though the actual command buffer was correct).
3. **Prompt truncated on up-arrow** — Hitting up-arrow to recall history would chop the prompt (e.g. `user@host:` became `user@ho`).

## Root Causes

- **Problem 1 (local):** Windows ConPTY has long-standing bugs with cursor tracking on wrapped lines. Every terminal on Windows (WezTerm, Windows Terminal, Alacritty) uses ConPTY for native shells and hits this.
- **Problem 1 (SSH):** Same ConPTY layer was sitting between WezTerm and the SSH connection.
- **Problem 2:** Byobu/tmux had `allow-passthrough off`, stripping bracketed paste escape sequences. The shell couldn't distinguish paste from typed input, causing display sync issues.
- **Problem 3:** `byobu_prompt_runtime` outputs a variable-length string (e.g. `[0.001s]`, `[42.315s]`). When readline redraws the prompt on up-arrow, the runtime value changes length, throwing off cursor position math.

## Fixes

### WezTerm: SSH Domains (bypasses ConPTY for SSH)

In `~/.config/wezterm/features/ssh.lua`, SSH domains are loaded from `hosts.lua` (gitignored) with `multiplexing = 'None'` so WezTerm's built-in SSH client handles the connection directly instead of going through ConPTY. See `hosts.example.lua` for the format.

Session persistence is handled by tmux/byobu on the remote side.

Connect as a new tab in the current window with:

```
wezterm cli spawn --domain-name <name>
```

### WezTerm: PSReadLine upgrade (mitigates ConPTY locally)

Upgraded PSReadLine from 2.3.6 to 2.4.5 which has better ConPTY workarounds for local PowerShell:

```powershell
Install-Module PSReadLine -Force -SkipPublisherCheck
```

### Remote: Allow passthrough in tmux/byobu

Enables bracketed paste sequences to pass through tmux to the shell, fixing paste display.

```bash
# Apply live
tmux set -g allow-passthrough on

# Make permanent
echo "set -g allow-passthrough on" >> ~/.byobu/.tmux.conf
```

### Remote: Remove variable-width runtime from prompt

Removes `byobu_prompt_runtime` from PS1 so readline can accurately calculate prompt width on redraw.

Add to `~/.bashrc` on the remote (after byobu sets its prompt):

```bash
export PS1='\[\e[38;5;202m\]$(byobu_prompt_status)\[\e[00m\] \[\e[38;5;245m\]\u\[\e[00m\]@\[\e[38;5;172m\]\h\[\e[00m\]:\[\e[38;5;5m\]\w\[\e[00m\]$(byobu_prompt_symbol) '
```

## Quick Setup Checklist for a New Remote

1. SSH in and open byobu
2. Run: `tmux set -g allow-passthrough on`
3. Run: `echo "set -g allow-passthrough on" >> ~/.byobu/.tmux.conf`
4. Run: `echo 'export PS1='"'"'\[\e[38;5;202m\]$(byobu_prompt_status)\[\e[00m\] \[\e[38;5;245m\]\u\[\e[00m\]@\[\e[38;5;172m\]\h\[\e[00m\]:\[\e[38;5;5m\]\w\[\e[00m\]$(byobu_prompt_symbol) '"'" >> ~/.bashrc`
5. Add the host to `ssh_domains` in `features/ssh.lua` with `multiplexing = 'None'` (or `'WezTerm'` if `wezterm-mux-server` is running on the remote for persistent sessions)
