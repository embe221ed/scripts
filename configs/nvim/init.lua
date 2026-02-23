-- IMPORTS
require('globals')              -- custom global options (load first)
require('opts')                 -- options
require('plugins')              -- plugins

require('misc.autocmds')        -- autocmds
require('misc.keys')            -- keymaps
require('misc.functions')       -- custom functions

require('editor.dev.snippets')  -- LuaSnip custom snippets
require('editor.dev.lsp')       -- LSP config
require('editor._quicker')      -- Improved UI and workflow for the Neovim quickfix  

require('ui.devicons')          -- nvim-web-devicons
require('languages')            -- tree-sitter languages

require('_markview')

-- plugins that depend on vim.g.colors (set by colorscheme)
local hooks = require("ibl.hooks")
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "IblScope", { fg = vim.g.colors.accent })
end)
require("ibl").setup {
  indent = { tab_char = "▏", char = "▏" },
  scope = { char = "▎" },
  exclude = { filetypes = { "dashboard" } },
}

require("todo-comments").setup {
  keywords = {
    AUDIT       = { icon = "󰒃 ", color = "audit", alt = { "SECURITY" } },
    QUESTION    = { icon = " ", color = "question", alt = { "Q", "ASK" } },
    FINDING     = { icon = "󰈸 ", color = "error", alt = { "BUG", "ISSUE" } },
    SUGGESTION  = { icon = " ", color = "sugg", alt = { "NIT", "SUG" } },
    NOTE        = { icon = " ", color = "hint", alt = { "INFO" } },
    IDEA        = { icon = " ", color = "idea" },
  },
  colors = {
    idea      = { vim.g.colors.yellow },
    audit     = { vim.g.colors.purple },
    question  = { vim.g.colors.sky },
    sugg      = { vim.g.colors.teal },
  },
}

-- load after colorscheme to apply correct highlights
require('ui.components.nvimtree')
require('ui.components.lualine')
require('ui.components.bufferline')
require('ui.components.noice')
require('ui.components.statuscol')

require('editor.dev.dap') -- DAP configs
require('editor.bookmarks')

if vim.g.neovide then require('neovide') end
