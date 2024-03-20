-- This file can be loaded by calling `lua require("plugins")` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local opts = {
  ui = {
    border = "rounded"
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

-- return require("packer").startup(function(use)
return require("lazy").setup(
  {
    {
      "nvim-tree/nvim-tree.lua",                                      -- filesystem navigation
      dependencies = { "nvim-tree/nvim-web-devicons" }                -- filesystem icons
    },
    -- { "catppuccin/nvim", name = "catppuccin" },                       -- catppuccin theme plugin
    { "embe221ed/onedark.nvim", name = "onedark" },                   -- OneDark
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
    -- { "arkav/lualine-lsp-progress" },                              -- LSP progress bar
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
    {                                                                 -- Rust LSP
      'mrcjkb/rustaceanvim',
      version = "^3",
      event = "BufReadPost",
      ft = { 'rust' },
    },
    { "mfussenegger/nvim-jdtls" },                                    -- Java LSP
    {
      "scalameta/nvim-metals",                                        -- Scala LSP
      dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
      "rmagatti/goto-preview",                                        -- GoTo preview
    },
    {
      "nvim-telescope/telescope.nvim",                                -- telescope
      dependencies = { {"nvim-lua/plenary.nvim"}, },
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
      'glepnir/dashboard-nvim',                                       -- dashboard
      config = function()
        require('dashboard').setup {
          theme = 'hyper',
          config = {
            week_header = {
             enable = true,
            },
            shortcut = {
              {
                icon = '󰊳 ',
                desc = 'update',
                group = '@property',
                action = 'Lazy sync',
                key = 'u'
              },
              {
                icon = ' ',
                icon_hl = '@variable',
                desc = 'files',
                group = 'Label',
                action = 'Telescope find_files',
                key = 'f',
              },
              {
                icon = ' ',
                desc = 'search',
                group = 'DiagnosticHint',
                action = 'Telescope live_grep',
                key = 's',
              },
              {
                icon = ' ',
                desc = 'quit',
                group = 'DiagnosticError',
                action = 'quitall',
                key = 'q',
              },
              {
                icon = ' ',
                desc = 'lspdebug',
                group = 'Debug',
                action = 'lua vim.lsp.set_log_level("debug")',
                key = 'd',
              },
              -- {
              --   desc = ' dotfiles',
              --   group = 'Number',
              --   action = 'Telescope dotfiles',
              --   key = 'd',
              -- },
            },
          },
        }
      end,
      dependencies = {'nvim-tree/nvim-web-devicons'},
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
  },
  opts
)
