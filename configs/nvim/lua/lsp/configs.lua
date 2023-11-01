-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Set border for floating windows
local _border = "rounded"

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = _border
  }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = _border
  }
)

vim.diagnostic.config{
  float = {
    border = _border
  }
}

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

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable inlayHints if LSP provides such
  if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint ~= nil then
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

  require('illuminate').on_attach(client)
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    on_attach(client, bufnr)
  end,
})

-- language servers
local lsp = require('lspconfig')

-- -- -- pyright
lsp.pyright.setup({
  capabilities = capabilities
})
-- -- -- clangd
lsp.clangd.setup({
  capabilities = capabilities
})
-- -- -- tsserver
lsp.tsserver.setup({
  capabilities = capabilities
})
-- -- -- texlab
lsp.texlab.setup({
  capabilities = capabilities
})
-- -- -- move-analyzer
lsp.move_analyzer.setup({
  capabilities = capabilities
})
-- -- -- golang
lsp.gopls.setup({
  capabilities = capabilities,
  settings = {
    gopls = {
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true
      }
    }
  }
})
-- -- -- java
lsp.jdtls.setup({
  capabilities = capabilities
})
-- -- -- lua
lsp.lua_ls.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
      hint = {
        enable = true,
      },
    },
  },
}
-- -- -- solidity
lsp.solidity.setup({
  -- on_attach = on_attach, -- probably you will need this.
  capabilities = capabilities,
  settings = {
    -- example of global remapping
    -- solidity = { includePath = '', remapping = { ["@OpenZeppelin/"] = 'OpenZeppelin/openzeppelin-contracts@4.6.0/' } }
  },
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

local SymbolKind = vim.lsp.protocol.SymbolKind

require("symbol-usage").setup {
  kinds = {
    SymbolKind.Function,
--     SymbolKind.File,
--     SymbolKind.Module,
--     SymbolKind.Namespace,
    SymbolKind.Package,
    SymbolKind.Class,
    SymbolKind.Method,
--     SymbolKind.Property,
--     SymbolKind.Field,
    SymbolKind.Constructor,
--     SymbolKind.Enum,
    SymbolKind.Interface,
--     SymbolKind.Variable,
    SymbolKind.Constant,
--     SymbolKind.String,
--     SymbolKind.Number,
--     SymbolKind.Boolean,
--     SymbolKind.Array,
--     SymbolKind.Object,
--     SymbolKind.Key,
--     SymbolKind.Null,
--     SymbolKind.EnumMember,
    SymbolKind.Struct,
    SymbolKind.Event,
--     SymbolKind.Operator,
--     SymbolKind.TypeParameter,
  },
}
