-- IMPORTS
require('opts')           -- Options
require('keys')           -- Keymaps
require('plugins')        -- Plugins
require('snippets')       -- LuaSnip custom snippets
require('functions')      -- custom functions
require('lsp.configs')    -- LSP config
require('languages')      -- tree-sitter languages
require('lualineconfig')  -- LuaLine config

require('_render-markdown')
-- require('_markview')

local globals = require('globals')

vim.opt.termguicolors = true

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
-- -- nvim-tree
require('nvim-tree').setup {
  view = {
    adaptive_size = true,
    centralize_selection = false,
    width = 40,
    side = "left",
    preserve_window_proportions = true,
    number = false,
    relativenumber = false,
    signcolumn = "yes",
  },
  renderer = {
    add_trailing = true,
    full_name = true,
    root_folder_label = function(path)
      return " " .. vim.fn.fnamemodify(path, ":t") .. "/"
    end,
    symlink_destination = false,
    indent_markers = {
      enable = true,
    },
    highlight_opened_files = "all",
  },
  actions = {
    open_file = {
      resize_window = false,
    }
  },
}
-- -- -- auto_close working implementation
vim.api.nvim_create_autocmd('BufEnter', {
    command = "if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif",
    nested = true,
})

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
require('nvim-autopairs').setup {}

-- -- telescope
require('telescope').setup { }
-- -- -- load additional plugins
require("telescope").load_extension("file_browser")

-- -- -- telescope plenary
require('plenary.filetype').add_file('move')

  -- Set up nvim-cmp.
local cmp = require('cmp')
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

local kind_icons = {
  Text = "",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰇽",
  Variable = "󰂡",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰅲",
}

---@diagnostic disable-next-line: redundant-parameter
cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    completion = {
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
      col_offset = 0,
      side_padding = 1,
    },
    documentation = {
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
    },
  },
  formatting = {
    format = function(entry, vim_item)
      local kind = string.format('\t\t%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind
      require('lspkind').cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
      vim_item.kind = kind
      return vim_item
    end
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>']     = cmp.mapping.scroll_docs(-4),
    ['<C-f>']     = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>']     = cmp.mapping.abort(),
    ['<CR>']      = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
})

---@diagnostic disable: undefined-field
-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
---@diagnostic enable: undefined-field


require("illuminate").configure({
  filetypes_denylist = {
    'qf',
    'fugitive',
    'NvimTree',
    'dashboard'
  },
})

require('colorscheme')    -- colorscheme
local current_theme = globals.current_theme
local palette = globals.get_palette(globals.colorscheme, current_theme)

-- -- todo-comments
require("todo-comments").setup {
  keywords = {
    AUDIT       = { icon = "󰒃 ", color = "audit", alt = { "SECURITY" } },
    QUESTION    = { icon = " ", color = "question", alt = { "Q", "ASK" } },
    FINDING     = { icon = "󰈸 ", color = "error", alt = { "BUG", "ISSUE" } },
    SUGGESTION  = { icon = " ", color = "sugg", alt = { "NIT", "SUG" } },
    NOTE        = { icon = "", color = "hint", alt = { "INFO" } },
    IDEA        = { icon = " ", color = "idea" },
  },
  colors = {
    idea      = { palette.yellow },
    audit     = { palette.mauve },
    question  = { palette.sky },
    sugg      = { palette.teal },
  }
}


require('_bufferline')
require('colorizer').setup({
  '*';
  '!lazy';
  '!notify';
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
  rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
  }
}

require('treesitter-context').setup {
  enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 1, -- Maximum number of lines to collapse for a single context line
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

-- -- load custom highlights before `noice.nvim`
require('highlights')

-- -- noice
require("noice").setup {
  cmdline = {
    format = {
      cmdline =   { pattern = "^:", icon = "_", lang = "vim" },
      telescope = { pattern = "^:%s*Tel?e?s?c?o?p?e?%s+", icon = "", lang = "vim" },
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
  views = {
    cmdline_popup = {
      position = { row = "20%", col = "50%", },
      size = { width = "auto", height = "auto", },
      border = { style = "rounded" },
      filter_options = {},
      win_options = {
        winhighlight = {
          FloatBorder = "FloatBorder",
        },
      },
    },
  },
}


local hooks = require("ibl.hooks")
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "IblScope", { fg = palette.mauve })
end)

require("ibl").setup {
  indent = {
    tab_char = require("ibl.config").default_config.indent.char,
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

require("nvim-web-devicons").set_default_icon('', '#6d8086', 66)

-- obsidian vault integration
require("obsidian").setup({
  -- A list of vault names and paths.
  -- Each path should be the path to the vault root. If you use the Obsidian app,
  -- the vault root is the parent directory of the `.obsidian` folder.
  -- You can also provide configuration overrides for each workspace through the `overrides` field.
  workspaces = {
    {
      name = "notes",
      path = "~/Desktop/knowledge",
    },
    {
      name = "work",
      path = "~/Desktop/osec_io/knowledge/notes",
    },
    {
      name = "general",
      path = "~/Documents/Obsidian Vault",
    },
  },
})
