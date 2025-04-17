-- This file can be loaded by calling `lua require("plugins")` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local opts = {
  ui = {
    border = vim.g.border,
    backdrop = 100,
  },
}

---@diagnostic disable-next-line: undefined-field
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
    vim.g.colorscheme.plugin(),
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
    {
      "luukvbaal/statuscol.nvim",
      dependencies = { "lewis6991/gitsigns.nvim", opt = true }
    },
    "neovim/nvim-lspconfig",                                          -- Configurations for Nvim LSP
    "mfussenegger/nvim-dap",                                          -- Debug Adapter Protocol client implementation for Neovim
    { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
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
      "rmagatti/goto-preview",                                        -- GoTo preview
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
    require('editor.blink'),
    -- { "saadparwaiz1/cmp_luasnip" },                                   -- Snippets source for nvim-cmp
    -- {
    --   "L3MON4D3/LuaSnip",
    --   build = "make install_jsregexp",
    --   dependencies = {
    --     "rafamadriz/friendly-snippets"
    --   },
    -- },                                                                -- Snippets plugin
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
    require('ui.components.dashboard'),
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
    {
      "yetone/avante.nvim",
      event = "VeryLazy",
      lazy = false,
      version = "*", -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
      opts = {
        provider = "openai",
        openai = {
          endpoint = "https://api.openai.com/v1",
          model = "gpt-4.1",
          timeout = 30000, -- Timeout in milliseconds
          temperature = 0,
          max_tokens = 4096,
        },
        mappings = {
          diff = {
            ours = "<leader>co",
            theirs = "<leader>ct",
            all_theirs = "<leader>ca",
            both = "<leader>cb",
            cursor = "<leader>cc",
          },
        },
      },
      -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
      build = "make",
      dependencies = {
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "echasnovski/mini.pick", -- for file_selector provider mini.pick
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        -- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
        -- "ibhagwan/fzf-lua", -- for file_selector provider fzf
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        -- "zbirenbaum/copilot.lua", -- for providers='copilot'
      },
    }
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
