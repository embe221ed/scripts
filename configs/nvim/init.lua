-- IMPORTS
require('globals')             -- custom global options (load first)
require('opts')                -- options
require('plugins')             -- plugins

require('misc.autocmds')       -- autocmds
require('misc.keys')           -- keymaps
require('misc.functions')      -- custom functions

require('editor.dev.snippets') -- LuaSnip custom snippets
require('editor.dev.lsp')      -- LSP config

require('ui.devicons')         -- nvim-web-devicons
require('languages')           -- tree-sitter languages

require('_render-markdown')
-- require('_markview')


local utils = require('utils')

-- PLUGINS
-- -- guess indent
require('guess-indent').setup {
  auto_cmd = true,  -- Set to false to disable automatic execution
  override_editorconfig = false, -- Set to true to override settings set by .editorconfig
  filetype_exclude = {  -- A list of filetypes for which the auto command gets disabled
    "netrw",
    "tutor",
  },
  buftype_exclude = {  -- A list of buffer types for which the auto command gets disabled
    "help",
    "nofile",
    "terminal",
    "prompt",
  },
}

-- -- Comment
-- -- -- manually set comments for Move
local ft = require("Comment.ft")
ft.set('move', { '//%s', '/*%s*/' })
require('Comment').setup {
  comment_empty = false
}

-- -- Symbols Outline
require('outline').setup {
  outline_window = {
    relative_width = true,
    width = 20,
    show_cursorline = 'focus_in_outline',
    hide_cursor = true,
  },
  outline_items = {
    -- show_symbol_lineno = true,
  },
  preview_window = {
    auto_preview = true,
    open_hover_on_preview = true,
    live = true,
  },
  symbols = {
    icon_source = "lspkind"
  },
}

-- -- auto-pairs
require('nvim-autopairs').setup({})

-- -- telescope
require('telescope').setup({
  -- extensions = {
  --   ["ui-select"] = {
  --     require('telescope.themes').get_dropdown({}),
  --   },
  -- },
})
-- -- -- load additional plugins
require("telescope").load_extension("file_browser")
-- require("telescope").load_extension("ui-select")

-- -- -- telescope plenary
require('plenary.filetype').add_file('move')

  -- Set up nvim-cmp.
-- local cmp = require('cmp')
local luasnip = require('luasnip')
require("luasnip.loaders.from_vscode").lazy_load()

-- -- LuaSnip keymaps
vim.keymap.set({"i"}, "<C-K>", function() luasnip.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-L>", function() luasnip.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-J>", function() luasnip.jump(-1) end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-E>", function()
	if luasnip.choice_active() then
		luasnip.change_choice(1)
	end
end, {silent = true})

-- local kind_icons = {
--   Text = "",
--   Method = "󰆧",
--   Function = "󰊕",
--   Constructor = "",
--   Field = "󰇽",
--   Variable = "󰂡",
--   Class = "󰠱",
--   Interface = "",
--   Module = "",
--   Property = "󰜢",
--   Unit = "",
--   Value = "󰎠",
--   Enum = "",
--   Keyword = "󰌋",
--   Snippet = "",
--   Color = "󰏘",
--   File = "󰈙",
--   Reference = "",
--   Folder = "󰉋",
--   EnumMember = "",
--   Constant = "󰏿",
--   Struct = "",
--   Event = "",
--   Operator = "󰆕",
--   TypeParameter = "󰅲",
-- }

---@diagnostic disable-next-line: redundant-parameter
-- cmp.setup({
--   snippet = {
--     -- REQUIRED - you must specify a snippet engine
--     expand = function(args)
--       luasnip.lsp_expand(args.body) -- For `luasnip` users.
--     end,
--   },
--   window = {
--     completion = {
--       winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
--       col_offset = -3,
--       side_padding = 0,
--     },
--   },
--   formatting = {
--     fields = { "kind", "abbr", "menu" },
--     format = function(entry, vim_item)
--       local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
--       local strings = vim.split(kind.kind, "%s", { trimempty = true })
--       kind.kind = " " .. (strings[1] or "") .. " "
--       kind.menu = "    (" .. (strings[2] or "") .. ")"
--
--       return kind
--     end,
--   },
--   mapping = cmp.mapping.preset.insert({
--     ['<C-b>']     = cmp.mapping.scroll_docs(-4),
--     ['<C-f>']     = cmp.mapping.scroll_docs(4),
--     ['<C-Space>'] = cmp.mapping.complete(),
--     ['<C-e>']     = cmp.mapping.abort(),
--     ['<CR>']      = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--   }),
--   sources = cmp.config.sources({
--     { name = 'nvim_lsp' },
--     { name = 'luasnip' }, -- For luasnip users.
--   }, {
--     { name = 'buffer' },
--     { name = 'path' },
--   })
-- })

---@diagnostic disable: undefined-field
-- Set configuration for specific filetype.
-- cmp.setup.filetype('gitcommit', {
--   sources = cmp.config.sources({
--     { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
--   }, {
--     { name = 'buffer' },
--   })
-- })

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline({ '/', '?' }, {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = 'buffer' }
--   }
-- })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     { name = 'cmdline' }
--   })
-- })
---@diagnostic enable: undefined-field


require("illuminate").configure({
  filetypes_denylist = {
    'qf',
    'fugitive',
    'NvimTree',
    'dashboard'
  },
})

require('ui.colorscheme')   -- colorscheme

-- -- todo-comments
require("todo-comments").setup {
  keywords = {
    AUDIT       = { icon = "󰒃 ", color = "audit", alt = { "SECURITY" } },
    QUESTION    = { icon = " ", color = "question", alt = { "Q", "ASK" } },
    FINDING     = { icon = "󰈸 ", color = "error", alt = { "BUG", "ISSUE" } },
    SUGGESTION  = { icon = " ", color = "sugg", alt = { "NIT", "SUG" } },
    NOTE        = { icon = " ", color = "hint", alt = { "INFO" } },
    IDEA        = { icon = " ", color = "idea" },
  },
  colors = {
    idea      = { vim.g.colors.yellow },
    audit     = { vim.g.colors.mauve },
    question  = { vim.g.colors.sky },
    sugg      = { vim.g.colors.teal },
  },
}


require('colorizer').setup({
  '*';
  '!lazy';
  '!notify';
  '!Outline';
})

require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "cpp", "lua", "rust", "python", "javascript", "markdown", "markdown_inline" },
  ignore_install = {},
  modules = {},

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    disable = { "latex", "dockerfile" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

require('rainbow-delimiters.setup').setup({
  query = {
    move = 'rainbow-delimiters',
  }
})

require('treesitter-context').setup {
  enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 1,  -- Maximum number of lines to collapse for a single context line
  trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
  zindex = 20,              -- The Z-index of the context window
  on_attach = nil,          -- (fun(buf: integer): boolean) return false to disable attaching
}
local ctx_render = require('treesitter-context.render')
local _open = ctx_render.open
---@diagnostic disable-next-line: duplicate-set-field
ctx_render.open = function(bufnr, winid, ctx_ranges, ctx_lines)
  _open(bufnr, winid, ctx_ranges, ctx_lines)
  vim.cmd('IBLEnableScope')
end


local hooks = require("ibl.hooks")
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "IblScope", { fg = vim.g.colors.accent })
end)

require("ibl").setup {
  indent = {
    tab_char = "▏",
    char = "▏",
  },
  scope = {
    char = "▎",
  },
  exclude = {
    filetypes = {
      "dashboard",
    }
  }
}

-- center the current buffer
require("no-neck-pain").setup({
  buffers = {
    scratchPad = {
      -- When `true`, automatically sets the following options to the side buffers:
      -- - `autowriteall`
      -- - `autoread`.
      --- @type boolean
      enabled = true,
      location = os.getenv("HOME") .. "/Desktop/nnp-notes/",
    },
  },
})

-- obsidian vault integration
local is_directory = utils.is_directory
local workspaces = {
    { name = "notes",   path = "~/Desktop/knowledge", },
    { name = "work",    path = "~/Desktop/osec_io/knowledge/notes", },
    { name = "general", path = "~/Documents/Obsidian Vault", },
}
for i = #workspaces, 1, -1 do
    local el = workspaces[i]
    if not is_directory(el.path) then
        table.remove(workspaces, i)
    end
end

if #workspaces > 0 then
  require("obsidian").setup({
    -- A list of vault names and paths.
    -- Each path should be the path to the vault root. If you use the Obsidian app,
    -- the vault root is the parent directory of the `.obsidian` folder.
    -- You can also provide configuration overrides for each workspace through the `overrides` field.
    workspaces = workspaces,
    ui = { enable = false },
    completion = {
      nvim_cmp = false,
      blink = true,
    },
  })
end

-- load after colorscheme to apply correct highlights
require('ui.components.nvimtree')
require('ui.components.lualine')
require('ui.components.bufferline')
require('ui.components.noice')
require('ui.components.statuscol')

require('editor.dev.dap') -- DAP configs
require('editor.bookmarks')

if vim.g.neovide then require('neovide') end
