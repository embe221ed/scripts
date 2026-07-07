-- snacks.dashboard configuration
-- returned into misc/_snacks.lua as opts.dashboard (UI-5: migrated off dashboard-nvim)

local header = [[


 ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗  █████╗ ██████╗ ██████╗
 ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██╔══██╗
 ██║  ██║███████║███████╗███████║██████╔╝██║   ██║███████║██████╔╝██║  ██║
 ██║  ██║██╔══██║╚════██║██╔══██║██╔══██╗██║   ██║██╔══██║██╔══██╗██║  ██║
 ██████╔╝██║  ██║███████║██║  ██║██████╔╝╚██████╔╝██║  ██║██║  ██║██████╔╝
 ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝
]]

return {
  enabled = true,
  preset = {
    header = header,
    keys = {
      { key = "u", desc = "Update plugins",  action = ":Lazy sync" },
      { key = "f", desc = "Find file",       action = function() Snacks.picker.files() end },
      { key = "e", desc = "File explorer",   action = function() Snacks.explorer.open() end },
      { key = "h", desc = "Recent files",    action = function() Snacks.picker.recent() end },
      { key = "r", desc = "Restore session", action = function() require('persistence').load() end },
      { key = "s", desc = "Sessions",        action = function() require('persistence').select() end },
      { key = "w", desc = "Find word",       action = function() Snacks.picker.grep() end },
      { key = "d", desc = "LSP debug level", action = ':lua vim.lsp.log.set_level("debug")' },
      { key = "q", desc = "Quit",            action = ":qa" },
    },
  },
  sections = {
    { section = "header" },
    { section = "keys", gap = 1, padding = 1 },
  },
}
