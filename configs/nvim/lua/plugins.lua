-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use {
    'kyazdani42/nvim-tree.lua',									-- filesystem navigation
    requires = 'kyazdani42/nvim-web-devicons'					-- filesystem icons
  }
  use 'marko-cerovac/material.nvim'								-- material theme plugin
  use {
    'nvim-treesitter/nvim-treesitter',							-- tree-sitter functionality and highlighting
    run = ':TSUpdate'
  }
  use 'p00f/nvim-ts-rainbow'									-- rainbow parentheses
  use {
    'nvim-lualine/lualine.nvim',								-- status line
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }	-- filesystem icons
  }
  use 'neovim/nvim-lspconfig'									-- Configurations for Nvim LSP
  use {
    'ms-jpq/coq_nvim',											-- Fast as FUCK and loads of features
    branch = 'coq'
  }
  use {
    'RRethy/vim-illuminate',									-- highlight word under cursor
    requires = 'neovim/nvim-lspconfig'
  }
  use {
    'akinsho/bufferline.nvim',									-- tabline for nvim
    tag = "v2.*",
    requires = 'kyazdani42/nvim-web-devicons'
  }
  use "windwp/nvim-autopairs"									-- auto-pairs
  use "lukas-reineke/indent-blankline.nvim"						-- indent blankline
end)
