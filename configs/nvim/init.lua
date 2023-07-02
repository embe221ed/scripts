-- IMPORTS
-- require('vars')         -- Variables
require('opts')         -- Options
require('keys')         -- Keymaps
require('plugins')         -- Plugins: UNCOMMENT THIS LINE

vim.opt.termguicolors = true

local function open_nvim_tree()
  -- open the tree
  require("nvim-tree.api").tree.toggle({
    focus = false
  })
end

-- PLUGINS
-- -- nvim-tree
require('nvim-tree').setup {
  view = {
    adaptive_size = true,
    centralize_selection = false,
    width = 40,
    hide_root_folder = false,
    side = "left",
    preserve_window_proportions = false,
    number = true,
    relativenumber = true,
    signcolumn = "yes",
    mappings = {
      custom_only = false,
      list = {
      -- user mappings go here
      },
    },
  }
}
-- -- -- auto_close working implementation
vim.api.nvim_create_autocmd('BufEnter', {
    command = "if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif",
    nested = true,
})
-- vim.api.nvim_create_autocmd({ "BufReadPre", "FileReadPre", "BufNewFile" }, {
--     callback = open_nvim_tree,
--     once = true
-- })

-- -- Comment
require('Comment').setup {
  comment_empty = false
}

-- -- todo-comments
require("todo-comments").setup {}

-- -- Symbols Outline
require('symbols-outline').setup {
  auto_preview = true,
  show_relative_numbers = true,
  show_numbers = true,
  relative_width = true,
  width = 15,
}

-- -- auto-pairs
require('nvim-autopairs').setup {}

-- -- telescope
require('telescope').setup {}

-- -- -- telescope plenary
require('plenary.filetype').add_file('move')

-- -- nvim-treesitter
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.move = {
  install_info = {
    url = "/opt/tree-sitter-parsers/tree-sitter-move/", -- local path or git repo
    files = {"src/parser.c"},
    -- optional entries:
    -- branch = "master", -- default branch in case of git repo if different from master
    generate_requires_npm = false, -- if stand-alone parser without npm dependencies
    requires_generate_from_grammar = true, -- if folder contains pre-generated src/parser.c
  }
}

require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "cpp", "lua", "rust", "python", "javascript" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    disable = { "latex" },

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

-- -- lualine
require('lualine').setup {
  options = {
    -- theme = 'material'
    theme = 'catppuccin',
  },
}

  -- Set up nvim-cmp.
local cmp = require('cmp')

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
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

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.

-- -- COQ config
-- vim.cmd [[
--   let g:coq_settings = { 'auto_start': v:true, 'keymap.jump_to_mark': v:null }
-- ]]
-- local coq = require('coq')
local border = {
      {"┌", "FloatBorder"},
      {"─", "FloatBorder"},
      {"┐", "FloatBorder"},
      {"│", "FloatBorder"},
      {"┘", "FloatBorder"},
      {"─", "FloatBorder"},
      {"└", "FloatBorder"},
      {"│", "FloatBorder"},
}
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- -- goto-preview config
require('goto-preview').setup {
  default_mappings = true;
  width = 150; -- Width of the floating window
  -- width = 200; -- Width of the floating window
  height = 40; -- Height of the floating window
}

-- -- LSP config
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

require("illuminate").configure({
  filetypes_denylist = {
    'qf',
    'fugitive',
    'NvimTree',
    'dashboard'
  },
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable inlayHints if LSP provides such
  if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint(bufnr, true)
  end
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
	vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
	vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)

  require('illuminate').on_attach(client)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

local lsp = require('lspconfig')

-- -- -- pyright
lsp.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities
})
-- -- -- clangd
lsp.clangd.setup({
  on_attach = on_attach,
  capabilities = capabilities
})
-- -- -- tsserver
lsp.tsserver.setup({
  on_attach = on_attach,
  capabilities = capabilities
})
-- -- -- texlab
lsp.texlab.setup({
  on_attach = on_attach,
  capabilities = capabilities
})
-- -- -- move-analyzer
lsp.move_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities
})
-- -- -- golang
lsp.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})
-- -- -- java
lsp.jdtls.setup({
  on_attach = on_attach,
  capabilities = capabilities
})
-- -- -- rls
-- lsp.rls.setup(
--   coq.lsp_ensure_capabilities({
-- 	settings = {
-- 	  rust = {
-- 		unstable_features = true,
-- 		build_on_save = false,
-- 		all_features = true,
-- 	  },
-- 	},
--   })
-- )
-- -- -- rust-analyzer
local rt = require("rust-tools")

local rust_on_attach = function(client, bufnr)
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
    vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "K", rt.hover_actions.hover_actions, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)

    require('illuminate').on_attach(client)
end

local opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        inlay_hints = {
            auto = true,
            show_parameter_hints = true,
            parameter_hints_prefix = "<- ",
            other_hints_prefix = "=> ",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        on_attach = rust_on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
}

rt.setup(opts)

-- -- -- metals (scala lsp)
local metals_config = require("metals").bare_config()

-- Example of settings
-- metals_config.settings = {
--   showImplicitArguments = true,
--   excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
-- }

metals_config.capabilities = capabilities
metals_config.on_attach = on_attach

-- Autocmd that will actually be in charging of starting the whole thing
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  -- NOTE: You may or may not want java included here. You will need it if you
  -- want basic Java support but it may also conflict if you are using
  -- something like nvim-jdtls which also works on a java filetype autocmd.
  pattern = { "scala", "sbt" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})

-- INITIALIZE MATERIAL SCHEME
-- vim.g.material_style = "palenight"
-- vim.cmd 'colorscheme material'

-- INITIALIZE CATPUCCIN SCHEME
require("catppuccin").setup({
    flavour = "frappe", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "frappe",
        dark = "frappe",
    },
    -- transparent_background = true,
    show_end_of_buffer = false, -- show the '~' characters after the end of buffers
    term_colors = false,
    dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.01,
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false,
    styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
    },
    color_overrides = {},
    custom_highlights = {},
    integrations = {
        cmp = true,
        symbols_outline = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        notify = false,
        illuminate = true,
        mini = false,
        indent_blankline = {
            enabled = true,
            colored_indent_levels = true,
        },
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = { "italic" },
                hints = { "italic" },
                warnings = { "italic" },
                information = { "italic" },
            },
            underlines = {
                errors = { "underline" },
                hints = { "underline" },
                warnings = { "underline" },
                information = { "underline" },
            },
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})
vim.cmd.colorscheme "catppuccin"

local frappe = require("catppuccin.palettes").get_palette "frappe"
local fg_selected = frappe.crust
-- local bg_selected = frappe.mantle
local bg_selected = frappe.base
local fg_visible = "#2f3445"
local bg_visible = "#1d1f2a"
require('bufferline').setup {
  highlights = require("catppuccin.groups.integrations.bufferline").get {
    styles = { "bold" },
    custom = {
      all = {
        fill = { bg = fg_selected, },

        background = { bg = bg_visible, },
        buffer_visible = { bg = bg_visible, },
        buffer_selected = { bg = bg_selected, },

        separator = { fg = fg_selected, bg = bg_visible },
        separator_visible = { fg = fg_selected, bg = bg_visible },
        separator_selected = { fg = fg_selected, bg = bg_selected, },

        close_button = { bg = bg_visible, },
        close_button_visible = { bg = bg_visible, },
        close_button_selected = { bg = bg_selected, },

        diagnostic = { bg = bg_visible, },
        diagnostic_visible = { bg = bg_visible, },
        diagnostic_selected = { bg = bg_selected, },

        pick = { bg = bg_visible, },
        pick_visible = { bg = bg_visible, },
        pick_selected = { bg = bg_selected, },

        hint = { bg = bg_visible, },
        hint_visible = { bg = bg_visible, },
        hint_selected = { bg = bg_selected, },

        info = { bg = bg_visible, },
        info_visible = { bg = bg_visible, },
        info_selected = { bg = bg_selected, },

        warning = { bg = bg_visible, },
        warning_visible = { bg = bg_visible, },
        warning_selected = { bg = bg_selected, },

        error = { bg = bg_visible, },
        error_visible = { bg = bg_visible, },
        error_selected = { bg = bg_selected, },

        modified = { bg = bg_visible, },
        modified_visible = { bg = bg_visible, },
        modified_selected = { bg = bg_selected, },

        duplicate = { bg = bg_visible, },
        duplicate_visible = { bg = bg_visible, },
        duplicate_selected = { bg = bg_selected, },

        numbers = { bg = bg_visible, },
        numbers_visible = { bg = bg_visible, },
        numbers_selected = { bg = bg_selected, },

        hint_diagnostic = { bg = bg_visible, },
        hint_diagnostic_visible = { bg = bg_visible, },
        hint_diagnostic_selected = { bg = bg_selected, },

        info_diagnostic = { bg = bg_visible, },
        info_diagnostic_visible = { bg = bg_visible, },
        info_diagnostic_selected = { bg = bg_selected, },

        warning_diagnostic = { bg = bg_visible, },
        warning_diagnostic_visible = { bg = bg_visible, },
        warning_diagnostic_selected = { bg = bg_selected, },

        error_diagnostic = { bg = bg_visible, },
        error_diagnostic_visible = { bg = bg_visible, },
        error_diagnostic_selected = { bg = bg_selected, },
      },
    }
  },
  options = {
    separator_style = "slant",
    diagnostics = "nvim_lsp",
    buffer_close_icon = "󰅖",
    offsets = {
      {
          filetype = "NvimTree",
          text = "  file explorer",
          separator = true,
      }
    },
  }
}

-- SETUP INDENT
-- vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
    show_current_context = true,
    show_current_context_start = true,
    space_char_blankline = " ",
    use_treesitter = true,
    char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
        "IndentBlanklineIndent6",
    },
}
