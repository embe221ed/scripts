-- This file can be loaded by calling `lua require("plugins")` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local generate_desc = require('globals').generate_desc

local opts = {
  ui = {
    border = "rounded",
    backdrop = 100,
  },
}

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

return require("lazy").setup(
  {
    {
      "nvim-tree/nvim-tree.lua",                                      -- filesystem navigation
      dependencies = { "nvim-tree/nvim-web-devicons" }                -- filesystem icons
    },
    -- { "catppuccin/nvim", name = "catppuccin" },                       -- catppuccin theme plugin
    {                                                                 -- tokyonight theme plugin
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },
    {
      "nvim-treesitter/nvim-treesitter",                              -- tree-sitter functionality and highlighting
      build = ":TSUpdate"
    },
    {
      "nvim-treesitter/playground",
      dependencies = { 'nvim-treesitter/nvim-treesitter' }
    },
    {
      "nvim-treesitter/nvim-treesitter-context",
      dependencies = { 'nvim-treesitter/nvim-treesitter' }
    },                                                                -- pin the current context at the top of the screen
    {
      "nvim-lualine/lualine.nvim",                                    -- status line
      dependencies = { "nvim-tree/nvim-web-devicons", opt = true },   -- filesystem icons
    },
    "neovim/nvim-lspconfig",                                          -- Configurations for Nvim LSP
    {
      "RRethy/vim-illuminate",                                        -- highlight word under cursor
      dependencies = "neovim/nvim-lspconfig"
    },
    {
      "akinsho/bufferline.nvim",                                      -- tabline for nvim
      dependencies = { "nvim-tree/nvim-web-devicons" },               -- filesystem icons
    },
    "windwp/nvim-autopairs",                                          -- auto-pairs
    "lukas-reineke/indent-blankline.nvim",                            -- indent blankline
    "HiPhish/rainbow-delimiters.nvim",                                -- rainbow parens
    {                                                                 -- Rust LSP
      'mrcjkb/rustaceanvim',
      event = "BufReadPost",
      ft = { 'rust' },
    },
    { "mfussenegger/nvim-jdtls" },                                    -- Java LSP
    {
      "scalameta/nvim-metals",                                        -- Scala LSP
      dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
      -- "rmagatti/goto-preview",                                        -- GoTo preview
      "embe221ed/goto-preview",                                       -- GoTo preview (fixed vim.lsp.handlers)
      branch = "fix_get_config",
    },
    {
      "nvim-telescope/telescope.nvim",                                -- telescope
      dependencies = { "nvim-lua/plenary.nvim", },
    },
    {
      "nvim-telescope/telescope-file-browser.nvim",
      dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    },
    {
        "numToStr/Comment.nvim",                                      -- Comments
    },
    { "hedyhli/outline.nvim" },                                       -- Symbols bar
    {
      "Wansmer/symbol-usage.nvim",
      event = "LspAttach"
    },
    -- autocompletion
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/nvim-cmp" },
    { "saadparwaiz1/cmp_luasnip" },                                   -- Snippets source for nvim-cmp
    {
      "L3MON4D3/LuaSnip",
      build = "make install_jsregexp",
      dependencies = {
        "rafamadriz/friendly-snippets"
      },
    },                                                                -- Snippets plugin
    -- end

    { "lervag/vimtex" },                                              -- LaTeX
    {
      "tpope/vim-fugitive",                                           -- Git integration
      dependencies = { "tpope/vim-rhubarb" },                         -- :GBrowse
    },
    {
      "folke/todo-comments.nvim",                                     -- special comments like TODO, FIXME, BUG etc
      dependencies = "nvim-lua/plenary.nvim",
    },
    {
      "glepnir/dashboard-nvim",                                       -- dashboard
      config = function()
        require('dashboard').setup {
          theme = 'doom',
          config = {
            header = {
              '', '', '', '', '', '',
              ' ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗  █████╗ ██████╗ ██████╗  ',
              ' ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██╔══██╗ ',
              ' ██║  ██║███████║███████╗███████║██████╔╝██║   ██║███████║██████╔╝██║  ██║ ',
              ' ██║  ██║██╔══██║╚════██║██╔══██║██╔══██╗██║   ██║██╔══██║██╔══██╗██║  ██║ ',
              ' ██████╔╝██║  ██║███████║██║  ██║██████╔╝╚██████╔╝██║  ██║██║  ██║██████╔╝ ',
              ' ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝  ',
              '', '',
            },
            center = {
              {
                desc = generate_desc('update plugins'),
                desc_hl = 'Identifier',
                action = 'Lazy sync',
                key = 'u',
                key_hl = '@markup.strong',
                key_format = ' %s',
              },
              {
                icon_hl = 'Identifier',
                desc = generate_desc('find file'),
                desc_hl = 'Identifier',
                action = 'Telescope find_files',
                key = 'f',
                key_hl = '@markup.strong',
                key_format = ' %s',
              },
              {
                desc = generate_desc('open file explorer'),
                desc_hl = 'Identifier',
                action = 'Telescope file_browser',
                key = 'e',
                key_hl = '@markup.strong',
                key_format = ' %s',
              },
              {
                desc = generate_desc('recently opened'),
                desc_hl = 'Identifier',
                action = 'Telescope oldfiles',
                key = 'h',
                key_hl = '@markup.strong',
                key_format = ' %s',
              },
              {
                desc = generate_desc('restore session'),
                desc_hl = 'Identifier',
                action = 'lua require(\'persistence\').load()',
                key = 'r',
                key_hl = '@markup.strong',
                key_format = ' %s',
              },
              {
                desc = generate_desc('sessions'),
                desc_hl = 'Identifier',
                action = 'lua require(\'persistence\').select()',
                key = 's',
                key_hl = '@markup.strong',
                key_format = ' %s',
              },
              {
                desc = generate_desc('find word'),
                desc_hl = 'Identifier',
                action = 'Telescope live_grep',
                key = 'w',
                key_hl = '@markup.strong',
                key_format = ' %s',
              },
              {
                desc = generate_desc('LSP debug level'),
                desc_hl = 'Identifier',
                action = 'lua vim.lsp.set_log_level("debug")',
                key = 'd',
                key_hl = '@markup.strong',
                key_format = ' %s',
              },
              {
                desc = generate_desc('quit'),
                desc_hl = 'Identifier',
                action = 'quitall',
                key = 'q',
                key_hl = '@markup.strong',
                key_format = ' %s',
              },
            },
          },
        }
      end,
      dependencies = { 'nvim-tree/nvim-web-devicons' },
    },
    { 'nmac427/guess-indent.nvim' },                                  -- guess the indent type in the current buffer
    {
      "folke/noice.nvim",
      dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
      },
    },
    { 'onsails/lspkind.nvim' },                                       -- vscode-like pictograms
    { 'shortcuts/no-neck-pain.nvim' },                                -- center the current buffer
    {
      "epwalsh/obsidian.nvim",
      version = "*",  -- recommended, use latest release instead of latest commit
      lazy = true,
      ft = "markdown",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {},
      dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    },
    {
      "folke/persistence.nvim",
      event = "BufReadPre", -- this will only start session saving when an actual file was opened
      opts = {
        -- add any custom options here
      },
    },
    {                                                                 -- Neovim plugin to improve the default vim.ui interfaces
      "stevearc/dressing.nvim",
      opts = {},
    },
    {                                                                 -- A high-performance color highlighter for Neovim
      "norcalli/nvim-colorizer.lua",
    },
    -- {
    --   "OXY2DEV/markview.nvim",
    --   lazy = false,      -- Recommended
    --   dependencies = {
    --       -- You will not need this if you installed the
    --       -- parsers manually
    --       -- Or if the parsers are in your $RUNTIMEPATH
    --       "nvim-treesitter/nvim-treesitter",
    --       "nvim-tree/nvim-web-devicons"
    --   }
    -- },
  },
  opts
)
