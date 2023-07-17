-- This file can be loaded by calling `lua require("plugins")` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function(use)
  -- Packer can manage itself
  use "wbthomason/packer.nvim"
  use {
    "kyazdani42/nvim-tree.lua",                               -- filesystem navigation
    requires = { "kyazdani42/nvim-web-devicons" }             -- filesystem icons
  }
  use { "catppuccin/nvim", as = "catppuccin" }                -- cattpuccin theme plugin
  use {
    "nvim-treesitter/nvim-treesitter",                        -- tree-sitter functionality and highlighting
    run = ":TSUpdate"
  }
  -- use { "nvim-treesitter/playground" }
  use { "nvim-treesitter/nvim-treesitter-context" }           -- pin the current context at the top of the screen
  use "p00f/nvim-ts-rainbow"                                  -- rainbow parentheses
  use {
    "nvim-lualine/lualine.nvim",                              -- status line
    requires = { "kyazdani42/nvim-web-devicons", opt = true } -- filesystem icons
  }
  use { "arkav/lualine-lsp-progress" }                        -- LSP progress bar
  use "neovim/nvim-lspconfig"                                 -- Configurations for Nvim LSP
  use {
    "RRethy/vim-illuminate",                                  -- highlight word under cursor
    requires = "neovim/nvim-lspconfig"
  }
  use {
    "akinsho/bufferline.nvim",                                -- tabline for nvim
    requires = { "kyazdani42/nvim-web-devicons" }             -- filesystem icons
  }
  use "windwp/nvim-autopairs"                                 -- auto-pairs
  use "lukas-reineke/indent-blankline.nvim"                   -- indent blankline
  use {
    "simrat39/rust-tools.nvim",                               -- A plugin to improve your rust experience in neovim.
    requires = { "mfussenegger/nvim-dap" }
  }
  use { "mfussenegger/nvim-jdtls" }                           -- Java LSP
  use {
    "scalameta/nvim-metals",                                  -- Scala LSP
    requires = { "nvim-lua/plenary.nvim" }
  }
  use { "iamcco/markdown-preview.nvim" }                      -- Markdown preview in the browser
  use {
    "rmagatti/goto-preview",                                  -- GoTo preview
  }
  use {
    "nvim-telescope/telescope.nvim",                          -- telescope
    requires = { {"nvim-lua/plenary.nvim"} }
  }
  use {
      "numToStr/Comment.nvim",                                -- Comments
  }
  use { "simrat39/symbols-outline.nvim" }                     -- Symbols bar
  -- autocompletion
  use { "hrsh7th/cmp-nvim-lsp" }
  use { "hrsh7th/cmp-buffer" }
  use { "hrsh7th/cmp-path" }
  use { "hrsh7th/cmp-cmdline" }
  use { "hrsh7th/nvim-cmp" }
  use { "hrsh7th/cmp-vsnip" }
  use { "hrsh7th/vim-vsnip" }
  -- end

  use { "lervag/vimtex" }                                     -- LaTeX
  use {
    "tpope/vim-fugitive",                                     -- Git integration
    requires = { "tpope/vim-rhubarb" }                        -- :GBrowse
  }
  use {
    "folke/todo-comments.nvim",                               -- special comments like TODO, FIXME, BUG etc
    requires = "nvim-lua/plenary.nvim",
  }
  use {
    'glepnir/dashboard-nvim',                                 -- dashboard
    event = 'VimEnter',
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
              action = 'PackerSync',
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
    requires = {'nvim-tree/nvim-web-devicons'}
  }
end)
