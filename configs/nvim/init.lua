-- IMPORTS
-- require('vars')         -- Variables
require('opts')         -- Options
require('keys')         -- Keymaps
require('plugins')         -- Plugins: UNCOMMENT THIS LINE


-- PLUGINS
-- -- nvim-tree
require('nvim-tree').setup {
  open_on_tab = false,
  open_on_setup = true,
  open_on_setup_file = true,
  view = {
	adaptive_size = true,
	centralize_selection = false,
	width = 40,
	hide_root_folder = false,
	side = "left",
	preserve_window_proportions = false,
	number = false,
	relativenumber = false,
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

-- -- Comment
require('Comment').setup {}

-- -- Symbols Outline
require('symbols-outline').setup {}

-- -- auto-pairs
require('nvim-autopairs').setup {}

-- -- telescope
require('telescope').setup {}

-- -- nvim-treesitter
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
    theme = 'material'
  }
}

-- -- tabline
require('bufferline').setup {
  options = {}
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
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.

-- -- COQ config
-- vim.cmd [[
--   let g:coq_settings = { 'auto_start': v:true, 'keymap.jump_to_mark': v:null }
-- ]]
-- local coq = require('coq')

-- -- goto-preview config
require('goto-preview').setup {
  default_mappings = true;
  width = 120; -- Width of the floating window
  height = 20; -- Height of the floating window
}

-- -- LSP config
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
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
local opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
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
        on_attach = on_attach,
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

require('rust-tools').setup(opts)

-- INITIALIZE MATERIAL SCHEME
vim.g.material_style = "palenight"
vim.cmd 'colorscheme material'

-- SETUP INDENT
vim.opt.termguicolors = true
vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
    show_current_context = true,
    show_current_context_start = true,
    space_char_blankline = " ",
    char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
        "IndentBlanklineIndent6",
    },
}
