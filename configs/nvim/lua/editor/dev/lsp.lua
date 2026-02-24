-- set up LSP
local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

-- -- goto-preview config
require('goto-preview').setup({
  default_mappings = true,
  width = 120, -- Width of the floating window
  border = vim.g.goto_preview.border,
  opacity = vim.g.winblend, -- 0-100 opacity level of the floating window where 100 is fully transparent.
  height = 20, -- Height of the floating window
  preview_window_title = { enabled = true, position = "right" },
  post_open_hook = function(_, winid)
    local config = vim.api.nvim_win_get_config(winid)
    local max_length = vim.g.goto_preview.title_length
    local title = config.title[1][1]
    if string.match(title, "^ .* $") then return end
    title = vim.fn.fnamemodify(title, ':~:.')
    if #title > max_length then
      local path_parts = vim.fn.split(title, '/')
      local _title = ''
      local tmp = ''
      for i = #path_parts, 1, -1 do
          tmp = path_parts[i] .. (_title ~= '' and '/' .. _title or '')
          if #tmp >= max_length then break end
          _title = tmp
      end
      title = "···/" .. _title
    end
    title = " " .. title .. " "
    config.title = { { title } }
    vim.api.nvim_win_set_config(winid, config)
  end,
  references = { -- Configure the telescope UI for slowing the references cycling window.
    provider = "snacks", -- telescope|fzf_lua|snacks|mini_pick|default
  },
})

-- -- LSP config
vim.diagnostic.config({
  signs = {
    text = {
        [ vim.diagnostic.severity.ERROR ] = '',
        [ vim.diagnostic.severity.WARN ] = '',
        [ vim.diagnostic.severity.INFO ] = '',
        [ vim.diagnostic.severity.HINT ] = '',
    },
    numhl = {
        [ vim.diagnostic.severity.ERROR ] = 'ErrorMsg',
        [ vim.diagnostic.severity.WARN ] = 'WarningMsg',
        [ vim.diagnostic.severity.INFO ] = 'DiagnosticInfo',
        [ vim.diagnostic.severity.HINT ] = 'DiagnosticHint',
    },
  },
  virtual_lines = true,
})
local trouble = require("trouble")
local opts = { noremap=true, silent=true }
local open_float = function()
  local fopts = {
    border = vim.g.lsp.diagnostic.border,
  }
  vim.diagnostic.open_float(fopts)
end
vim.keymap.set('n', '<space>e', open_float, opts)
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, opts)
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, opts)
vim.keymap.set('n', '<space>dl', vim.diagnostic.setloclist, opts)
vim.keymap.set(
  'n',
  '<space>dq',
  function()
    vim.diagnostic.setqflist({ open = false })
    trouble.open({
      mode = "quickfix",
      win = { relative = "win", },
    })
  end,
  opts
)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable inlayHints if LSP provides such
  if (
    client.server_capabilities.inlayHintProvider
    and vim.lsp.inlay_hint ~= nil
    and not vim.lsp.inlay_hint.is_enabled({ buf = bufnr })) then
      vim.lsp.inlay_hint.enable(true, { buf = bufnr })
  end
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_set_option_value('formatexpr', 'v:lua.vim.lsp.formatexpr()',  { buf = bufnr })
  vim.api.nvim_set_option_value('omnifunc',   'v:lua.vim.lsp.omnifunc',      { buf = bufnr })
  vim.api.nvim_set_option_value('tagfunc',    'v:lua.vim.lsp.tagfunc',       { buf = bufnr })

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  -- vim.keymap.set('n', 'gD',        function() trouble.toggle("lsp_declarations") end, bufopts)
  -- vim.keymap.set('n', 'gd',        function() trouble.toggle("lsp_definitions") end, bufopts) -- does not add entry to tagstack
  vim.keymap.set('n', 'gD',        vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd',        vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K',         vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi',        function() trouble.toggle("lsp_implementations") end, bufopts)
  vim.keymap.set('n', 'gr',        function() trouble.toggle("lsp_references") end, bufopts)
  vim.keymap.set('n', 'gtd',       Snacks.picker.lsp_definitions, bufopts)
  vim.keymap.set('n', 'gtr',       Snacks.picker.lsp_references, bufopts)
  vim.keymap.set('n', 'gti',       Snacks.picker.lsp_implementations, bufopts)
  -- misc actions
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D',  vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    on_attach(client, bufnr)
  end,
})

-- language servers

-- -- -- python-lsp-server
vim.lsp.config('pylsp', {
  capabilities = capabilities
})
-- -- -- clangd
vim.lsp.config('clangd', {
  capabilities = capabilities
})
-- -- -- tsserver
vim.lsp.config('ts_ls', {
  capabilities = capabilities
})
-- -- -- vim-language-server
vim.lsp.config('vimls', {
  capabilities = capabilities
})
-- -- -- texlab
vim.lsp.config('texlab', {
  capabilities = capabilities
})
-- -- -- move-analyzer
vim.lsp.config('move_analyzer', {
  capabilities = capabilities,
  init_options = {
    inlayHintsParam = true,
    inlayHintsType = true,
  }
})
-- -- -- golang
vim.lsp.config('gopls', {
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
vim.lsp.config('jdtls', {
  capabilities = capabilities
})
-- -- -- lua
vim.lsp.config('lua_ls', {
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
})
-- -- -- solidity
vim.lsp.config('solidity_ls_nomicfoundation', {
  capabilities = capabilities,
  cmd = { 'nomicfoundation-solidity-language-server', '--stdio' },
  root_markers = {
    'hardhat.config.js',
    'hardhat.config.ts',
    'foundry.toml',
    'remappings.txt',
    'truffle.js',
    'truffle-config.js',
    'ape-config.yaml',
    ".git",
    "package.json",
  },
  single_file_support = true,
})
-- -- -- bash
vim.lsp.config('bashls', {
  capabilities = capabilities
})

-- -- -- cadence
vim.lsp.config('cadence-language-server', {
  capabilities = capabilities,
  cmd = { "flow", "cadence", "language-server" },
  filetypes = { "cadence" },
  root_dir = vim.fs.find({ "flow.json" }, { upward = true })[1],
  init_options = {
    numberOfAccounts = "1",
    configPath = vim.fs.find({ "flow.json" }, { upward = true })[1],
  }
})

-- -- -- rust (via rustaceanvim plugin)
vim.g.rustaceanvim = {
  tools = {
    float_win_config = {
      border = vim.g.border,
    },
  },
  server = {
    on_attach = function(client, bufnr)
      vim.keymap.set(
        "n",
        "<space>ca",
        function()
          vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
        end,
        { silent = true, buffer = bufnr }
      )
    end
  },
}

local SymbolKind = vim.lsp.protocol.SymbolKind

local function text_format(symbol)
  local fragments = {}

  if symbol.references then
    local num = symbol.references == 0 and 'no' or symbol.references
    table.insert(fragments, ('%s %s'):format(num, "usages"))
  end

  if symbol.definition then
    table.insert(fragments, symbol.definition .. ' defs')
  end

  if symbol.implementation then
    table.insert(fragments, symbol.implementation .. ' impls')
  end

  return table.concat(fragments, ', ')
end

require("symbol-usage").setup {
  text_format = text_format,
  kinds = {
    SymbolKind.Function,
    SymbolKind.Package,
    SymbolKind.Class,
    SymbolKind.Method,
    SymbolKind.Constructor,
    SymbolKind.Interface,
    SymbolKind.Constant,
    SymbolKind.Struct,
    SymbolKind.Event,
  },
  disable = { lsp = { "solidity_ls_nomicfoundation", "lua_ls" }, },
}
