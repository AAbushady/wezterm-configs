-- Copy this file to hosts.lua and fill in your SSH hosts.
-- hosts.lua is gitignored — your actual hosts stay private.
--
-- Fields:
--   name           — SSH domain name (used in launcher, tab titles, workspace layouts)
--   remote_address — hostname or IP (with optional :port)
--   username       — SSH username
--   color          — Catppuccin Mocha hex color for pane borders and tab accents
--
return {
  { name = 'myserver', remote_address = '192.168.1.100', username = 'user', color = '#89b4fa' },
}
