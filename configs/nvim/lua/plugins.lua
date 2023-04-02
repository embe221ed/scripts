-- This file can be loaded by calling `lua require("plugins")` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function(use)
  -- Packer can manage itself
  use "wbthomason/packer.nvim"
  use {
    "kyazdani42/nvim-tree.lua",                               -- filesystem navigation
    requires = "kyazdani42/nvim-web-devicons"                 -- filesystem icons
  }
  use "marko-cerovac/material.nvim"                           -- material theme plugin
  use { "catppuccin/nvim", as = "catppuccin" }                -- cattpuccin theme plugin
  use {
    "nvim-treesitter/nvim-treesitter",                        -- tree-sitter functionality and highlighting
    run = ":TSUpdate"
  }
  use { "nvim-treesitter/playground" }
  use "p00f/nvim-ts-rainbow"                                  -- rainbow parentheses
  use {
    "nvim-lualine/lualine.nvim",                              -- status line
    requires = { "kyazdani42/nvim-web-devicons", opt = true } -- filesystem icons
  }
  use "neovim/nvim-lspconfig"                                 -- Configurations for Nvim LSP
  use {
    "RRethy/vim-illuminate",                                  -- highlight word under cursor
    requires = "neovim/nvim-lspconfig"
  }
  use {
    "akinsho/bufferline.nvim",                                -- tabline for nvim
    tag = "v2.*",
    requires = "kyazdani42/nvim-web-devicons"
  }
  use "windwp/nvim-autopairs"                                 -- auto-pairs
  use "lukas-reineke/indent-blankline.nvim"                   -- indent blankline
  use "simrat39/rust-tools.nvim"                              -- A plugin to improve your rust experience in neovim.
  use { "iamcco/markdown-preview.nvim" }
  use {
    "rmagatti/goto-preview",                                  -- GoTo preview
    config = function()
      require("goto-preview").setup {}
    end
  }
  use {
    "nvim-telescope/telescope.nvim", tag = "0.1.0",           -- telescope
  -- or                            , branch = "0.1.x",
    requires = { {"nvim-lua/plenary.nvim"} }
  }
  use {
      "numToStr/Comment.nvim",
      config = function()
          require("Comment").setup()
      end
  }
  -- autocompletion
  use { "simrat39/symbols-outline.nvim" }
  use { "hrsh7th/cmp-nvim-lsp" }
  use { "hrsh7th/cmp-buffer" }
  use { "hrsh7th/cmp-path" }
  use { "hrsh7th/cmp-cmdline" }
  use { "hrsh7th/nvim-cmp" }
  use { "hrsh7th/cmp-vsnip" }
  use { "hrsh7th/vim-vsnip" }
  -- end

  use { "lervag/vimtex" }                                     -- LaTeX
  -- use { "rvmelkonian/move.vim" }
  use {
    "jackMort/ChatGPT.nvim",
    requires = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  } 
  use { "tpope/vim-fugitive" }
  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
  }
end)
