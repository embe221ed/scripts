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
    { "catppuccin/nvim", name = "catppuccin" },                       -- catppuccin theme plugin
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
    {
      'saghen/blink.cmp',
      lazy = false, -- lazy loading handled internally
      -- optional: provides snippets for the snippet source
      dependencies = {
        { 'rafamadriz/friendly-snippets' },
        { 'L3MON4D3/LuaSnip', version = 'v2.*' },
      },

      -- use a release tag to download pre-built binaries
      version = 'v0.*',
      -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
      -- build = 'cargo build --release',
      -- If you use nix, you can build from source using latest nightly rust with:
      -- build = 'nix run .#build-plugin',

      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      ---@diagnostic disable: missing-fields
      opts = {
        -- 'default' for mappings similar to built-in completion
        -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
        -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
        -- see the "default configuration" section below for full documentation on how to define
        -- your own keymap.
        keymap = {
          preset = 'enter',
          ['<Tab>']   = { 'select_next', 'fallback' },
          ['<S-Tab>'] = { 'select_prev', 'fallback' },
          ['<C-L>']   = { 'snippet_forward', 'fallback' },
          ['<C-J>']   = { 'snippet_backward', 'fallback' },
        },

        appearance = {
          -- Sets the fallback highlight groups to nvim-cmp's highlight groups
          -- Useful for when your theme doesn't support blink.cmp
          -- will be removed in a future release
          use_nvim_cmp_as_default = true,
          -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = 'mono'
        },
        snippets = {
          expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
          active = function(filter)
            if filter and filter.direction then
              return require('luasnip').jumpable(filter.direction)
            end
            return require('luasnip').in_snippet()
          end,
          jump = function(direction) require('luasnip').jump(direction) end,
        },

        -- default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, via `opts_extend`
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
        completion = {
          list = {
            selection = { preselect = false, auto_insert = true, }
          },
          menu = {
            draw = {
              treesitter = { 'lsp' },
              columns = {
                { "label", "label_description", gap = 3 },
                { "kind_icon", "kind", gap = 1 },
              },
              components = {
                label_description = {
                  highlight = 'Comment',
                },
              }
            }
          },
          documentation = {
            auto_show = true,
            window = {
              min_width = 10,
              max_width = 150,
              max_height = 40,
              border = 'padded',
              winblend = 0,
              winhighlight = 'Normal:NoicePopup,FloatBorder:NoicePopup,CursorLine:BlinkCmpDocCursorLine,Search:None',
              -- Note that the gutter will be disabled when border ~= 'none'
              scrollbar = true,
              -- Which directions to show the documentation window,
              -- for each of the possible menu window directions,
              -- falling back to the next direction when there's not enough space
              direction_priority = {
                menu_north = { 'e', 'w', 'n', 's' },
                menu_south = { 'e', 'w', 's', 'n' },
              },
            },
          },
        },

        -- experimental signature help support
        -- signature = { enabled = true }
      },
      ---@diagnostic enable: missing-fields
      -- allows extending the providers array elsewhere in your config
      -- without having to redefine it
      opts_extend = { "sources.default" }
    },
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
    {
      "yetone/avante.nvim",
      event = "VeryLazy",
      lazy = false,
      version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
      opts = {
        provider = "openai",
        openai = {
          endpoint = "https://api.openai.com/v1",
          model = "gpt-4o-mini",
          timeout = 30000, -- Timeout in milliseconds
          temperature = 0,
          max_tokens = 4096,
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
