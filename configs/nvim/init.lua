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

-- load after colorscheme to apply correct highlights
require('ui.components.lualine')
require('ui.components.bufferline')
require('ui.components.statuscol')

require('editor.bookmarks')

if vim.g.neovide then require('neovide') end
