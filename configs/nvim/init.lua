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
      return "  " .. vim.fn.fnamemodify(path, ":t") .. "/"
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

-- -- todo-comments
require("todo-comments").setup {
  keywords = {
    AUDIT       = { icon = "󰒃 ", color = "audit" },
    QUESTION    = { icon = " ", color = "question" },
    FINDING     = { icon = "󰈸 ", color = "error", alt = { "BUG", "ISSUE" } },
    SUGGESTION  = { icon = " ", color = "sugg", alt = { "NIT", "SUG" } },
    IDEA        = { icon = " ", color = "idea" },
  },
  colors = {
    idea      = { "#ffd600" },
    audit     = { "#de85f5" },
    question  = { "#2e7de9" },
    sugg      = { "#07879d" },
  }
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

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    completion = {
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
      col_offset = -3,
      side_padding = 0,
    },
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
      local strings = vim.split(kind.kind, "%s", { trimempty = true })
      kind.kind = " " .. (strings[1] or "") .. " "
      kind.menu = "    (" .. (strings[2] or "") .. ")"

      return kind
    end,
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


require("illuminate").configure({
  filetypes_denylist = {
    'qf',
    'fugitive',
    'NvimTree',
    'dashboard'
  },
})

-- Catppuccin theme
-- local current_theme = globals.current_theme
-- local palette = require("catppuccin.palettes").get_palette(current_theme)
-- require('catppuccin').setup  {
--     flavour = current_theme, -- latte, frappe, macchiato, mocha
--     transparent_background = false, -- disables setting the background color.
--     show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
--     term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
--     dim_inactive = {
--         enabled = false, -- dims the background color of inactive window
--         shade = "dark",
--         percentage = 0.15, -- percentage of the shade to apply to the inactive window
--     },
--     no_italic = false, -- Force no italic
--     no_bold = false, -- Force no bold
--     no_underline = false, -- Force no underline
--     styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
--         comments = { "italic" }, -- Change the style of comments
--         conditionals = { "italic" },
--         loops = {},
--         functions = {},
--         keywords = {},
--         strings = {},
--         variables = {},
--         numbers = {},
--         booleans = {},
--         properties = {},
--         types = {},
--         operators = {},
--         -- miscs = {}, -- Uncomment to turn off hard-coded styles
--     },
--     color_overrides = {
--       frappe = {
--         lavender = "#b4b5ee",
--       }
--     },
--     custom_highlights = {
--         NoicePopup                  = { bg = palette.mantle },
--         TabLineSel                  = { bg = palette.mauve },
--         FloatBorder                 = { fg = palette.mauve, bg = palette.base, style = { "bold" } },
--         StatusLine                  = { fg = palette.base, bg = palette.base },
--         StatusLineNC                = { fg = palette.base, bg = palette.base },
--         OutlineCurrent              = { fg = palette.green, bg = "", style = { "bold" } },
--         TelescopeTitle              = { fg = palette.cyan },
--         TelescopeBorder             = { fg = palette.mauve },
--         NvimTreeExecFile            = { fg = palette.red },
--         -- TreesitterContext           = { bg = palette.mantle },
--         NvimTreeOpenedHL            = { fg = palette.subtext0, style = { "italic" } },
--         NvimTreeRootFolder          = { fg = palette.peach },
--         NvimTreeStatusLine          = { fg = palette.base, bg = palette.base },
--         NvimTreeStatusLineNC        = { fg = palette.base, bg = palette.base },
--         NoiceCmdlinePopupBorder     = { fg = palette.mauve },
--         -- TreesitterContextLineNumber = { bg = palette.mantle, fg = palette.surface1 },
--     }, -- Override highlight groups
--     default_integrations = false,
--     integrations = {
--         cmp = true,
--         gitsigns = true,
--         nvimtree = true,
--         treesitter = true,
--         notify = false,
--         mini = {
--             enabled = true,
--             indentscope_color = "",
--         },
--         -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
--     },
-- }

local current_theme = globals.current_theme
local palette = globals.get_palette(globals.colorscheme, current_theme)
---@class tokyonight.Config
require('tokyonight').setup({
  style = current_theme, -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
  light_style = "day", -- The theme is used when the background is set to light
  transparent = false, -- Enable this to disable setting the background color
  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = true },
    conditionals = { italic = true },
    keywords = {},
    functions = {},
    variables = {},
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = "dark", -- style for sidebars, see below
    floats = "dark", -- style for floating windows
  },
  day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
  dim_inactive = false, -- dims inactive windows
  lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

  --- You can override specific color groups to use other groups or a hex color
  --- function will be called with a ColorScheme table
  ---@param colors ColorScheme
  on_colors = function(colors)
    colors.border_highlight = "#29a4bd"
  end,

  --- You can override specific highlights to use other groups or a hex color
  --- function will be called with a Highlights and ColorScheme table
  ---@param highlights tokyonight.Highlights
  ---@param colors ColorScheme
  on_highlights = function(highlights, colors)
    highlights.NoicePopup                  = { bg = colors.bg_dark }
    -- highlights.TabLineSel                  = { bg = colors.mauve }
    highlights.FloatBorder                 = { fg = colors.border_highlight, bg = colors.bg, bold = true }
    highlights.FloatTitle                  = { fg = colors.border_highlight, bg = colors.bg }
    highlights.StatusLine                  = { fg = colors.bg, bg = colors.bg }
    highlights.StatusLineNC                = { fg = colors.bg, bg = colors.bg }
    highlights.OutlineCurrent              = { fg = colors.green, bg = "", bold = true }
    highlights.TelescopeTitle              = { fg = colors.cyan }
    highlights.TelescopePromptTitle        = { fg = colors.orange, bg = colors.bg }
    highlights.TelescopeNormal             = { bg = colors.bg }
    highlights.TelescopeBorder             = { fg = colors.border_highlight, bg = colors.bg }
    highlights.TelescopePromptBorder       = { fg = colors.orange, bg = colors.bg }
    highlights.NvimTreeExecFile            = { fg = colors.red }
    highlights.TreesitterContext           = { bg = colors.bg }
    highlights.NvimTreeOpenedHL            = { fg = colors.comment, italic = true }
    highlights.NvimTreeRootFolder          = { fg = colors.magenta2 }
    highlights.NvimTreeStatusLine          = { fg = colors.bg, bg = colors.bg }
    highlights.NvimTreeStatusLineNC        = { fg = colors.bg, bg = colors.bg }
    highlights.NvimTreeWinSeparator        = { fg = colors.bg, bg = colors.bg }
    -- highlights.NoiceCmdlinePopupBorder     = { fg = colors.mauve }
    -- highlights.TreesitterContextLineNumber = { bg = colors.mantle, fg = colors.surface1 }
  end,

  cache = true, -- When set to true, the theme will be cached for better performance

  ---@type table<string, boolean|{enabled:boolean}>
  plugins = {
    -- enable all plugins when not using lazy.nvim
    -- set to false to manually enable/disable plugins
    all = package.loaded.lazy == nil,
    -- uses your plugin manager to automatically enable needed plugins
    -- currently only lazy.nvim is supported
    auto = true,
    -- add any plugins here that you want to enable
    -- for all possible plugins, see:
    --   * https://github.com/folke/tokyonight.nvim/tree/main/lua/tokyonight/groups
    -- telescope = true,
    bufferline = false,
  },
})

vim.cmd.colorscheme(globals.colorscheme)

require('_bufferline')
require('colorizer').setup({
  '*';
  '!lazy';
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
      position = {
        row = "20%",
        col = "50%",
      },
      size = {
        width = "auto",
        height = "auto",
      },
      border = {
        style = "rounded",
      },
      filter_options = {},
      win_options = {
        winhighlight = {
          FloatBorder = "FloatBorder"
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

-- obsidian vault integration
require("obsidian").setup({
  -- A list of vault names and paths.
  -- Each path should be the path to the vault root. If you use the Obsidian app,
  -- the vault root is the parent directory of the `.obsidian` folder.
  -- You can also provide configuration overrides for each workspace through the `overrides` field.
  workspaces = {
    {
      name = "CTF",
      path = "~/Desktop/knowledge/CTF",
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
