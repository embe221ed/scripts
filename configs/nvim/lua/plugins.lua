local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local utils = require("utils")

local opts = {
  ui = {
    border = vim.g.neovide and "none" or vim.g.border,
    backdrop = utils.ternary(vim.g.border == "none", 70, 100),
  },
}

if not vim.uv.fs_stat(lazypath) then
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
    vim.g.colorscheme.plugin(),                                       -- load desired colorscheme
    {
      "nvim-treesitter/nvim-treesitter",                              -- tree-sitter functionality and highlighting
      build = ":TSUpdate",
      config = function()
        require('nvim-treesitter').install({ "c", "cpp", "lua", "rust", "python", "javascript", "markdown", "markdown_inline" })
        require('nvim-treesitter').setup {
          ignore_install = {},
          modules = {},
          sync_install = false,
          highlight = {
            enable = true,
            disable = { "latex", "dockerfile" },
            additional_vim_regex_highlighting = false,
          },
        }
      end,
    },
    {                                                                 -- pin the current context at the top of the screen
      "nvim-treesitter/nvim-treesitter-context",
      dependencies = { 'nvim-treesitter/nvim-treesitter' },
      config = function()
        require('treesitter-context').setup {
          enable = true,
          max_lines = 0,
          min_window_height = 0,
          line_numbers = true,
          multiline_threshold = 1,
          trim_scope = 'outer',
          mode = 'cursor',
          zindex = 20,
          on_attach = nil,
        }
        local ctx_render = require('treesitter-context.render')
        local _open = ctx_render.open
        ---@diagnostic disable-next-line: duplicate-set-field
        ctx_render.open = function(bufnr, winid, ctx_ranges, ctx_lines)
          _open(bufnr, winid, ctx_ranges, ctx_lines)
          vim.cmd('IBLEnableScope')
        end
      end,
    },
    {
      "nvim-lualine/lualine.nvim",                                    -- status line
      dependencies = { "nvim-tree/nvim-web-devicons", opt = true },   -- filesystem icons
    },
    {
      "luukvbaal/statuscol.nvim",                                     -- extended status column
      dependencies = { "lewis6991/gitsigns.nvim", opt = true }
    },
    "neovim/nvim-lspconfig",                                          -- configurations for nvim LSP
    "mfussenegger/nvim-dap",                                          -- D[ebug]A[dapter]P[rotocol] client implementation for neovim
    {                                                                 -- DAP UI
      "rcarriga/nvim-dap-ui",
      dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }
    },
    {
      "akinsho/bufferline.nvim",                                      -- tabline for nvim
      dependencies = { "nvim-tree/nvim-web-devicons" },               -- filesystem icons
    },
    {
      "windwp/nvim-autopairs",                                        -- auto-pairs
      event = "InsertEnter",
      opts = {},
    },
    "lukas-reineke/indent-blankline.nvim",                              -- indent blankline
    {
      "HiPhish/rainbow-delimiters.nvim",                              -- rainbow parens
      config = function()
        require('rainbow-delimiters.setup').setup({
          query = { move = 'rainbow-delimiters' }
        })
      end,
    },
    {                                                                 -- Rust LSP
      'mrcjkb/rustaceanvim',
      event = "BufReadPost",
      ft = { 'rust' },
    },
    {
      "rmagatti/goto-preview",                                        -- GoTo preview
      event = "LspAttach",
    },
    {
      "nvim-telescope/telescope.nvim",                                -- telescope
      cmd = "Telescope",
      dependencies = { "nvim-lua/plenary.nvim", },
      config = function()
        require('telescope').setup({
          defaults = { border = not vim.g.neovide },
        })
        require("telescope").load_extension("file_browser")
        require('plenary.filetype').add_file('move')
      end,
    },
    {                                                                 -- telescope picker for nice file tree
      "nvim-telescope/telescope-file-browser.nvim",
      dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    },
    {
      "numToStr/Comment.nvim",                                        -- easier comments management
      event = { "BufReadPost", "BufNewFile" },
      config = function()
        require("Comment.ft").set('move', { '//%s', '/*%s*/' })
        require('Comment').setup { comment_empty = false }
      end,
    },
    {
      "hedyhli/outline.nvim",                                         -- symbols outline
      cmd = "Outline",
      config = function()
        require('outline').setup {
          outline_window = {
            relative_width = true,
            width = 20,
            show_cursorline = 'focus_in_outline',
            hide_cursor = true,
          },
          preview_window = {
            auto_preview = true,
            open_hover_on_preview = true,
            winblend = vim.g.winblend,
            border = utils.ternary(vim.g.border == "none", { " " }, vim.g.border),
            winhl = 'NormalFloat:NormalFloat',
            live = true,
          },
          symbols = {
            icon_source = "lspkind"
          },
          symbol_folding = {
            markers = { vim.g.symbols.expand, vim.g.symbols.collapse }
          },
        }
      end,
    },
    {
      "Wansmer/symbol-usage.nvim",
      event = "LspAttach"
    },
    -- autocompletion
    require('editor.dev.blink'),
    {
      "tpope/vim-fugitive",                                           -- Git integration
      dependencies = { "tpope/vim-rhubarb" },                         -- :GBrowse
    },
    {
      "folke/todo-comments.nvim",                                     -- special comments like TODO, FIXME, BUG etc
      dependencies = "nvim-lua/plenary.nvim",
    },
    require('ui.components.dashboard'),
    {
      'nmac427/guess-indent.nvim',                                    -- guess the indent type in the current buffer
      opts = {
        auto_cmd = true,
        override_editorconfig = false,
        filetype_exclude = { "netrw", "tutor" },
        buftype_exclude = { "help", "nofile", "terminal", "prompt" },
      },
    },
    {
      "folke/noice.nvim",
      dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
      },
    },
    {
      "folke/trouble.nvim",
      cmd = "Trouble",
      specs = {
        "folke/snacks.nvim",
        opts = function(_, _opts)
          return vim.tbl_deep_extend("force", _opts or {}, {
            picker = {
              actions = require("trouble.sources.snacks").actions,
              win = {
                input = {
                  keys = {
                    [ "<c-t>" ] = {
                      "trouble_open",
                      mode = { "n", "i" },
                    },
                  },
                },
                list = {
                  keys = {
                    [ "<c-t>" ] = {
                      "trouble_open",
                      mode = { "n", "i" },
                    },
                  },
                },
              },
            },
          })
        end,
      },
      opts = {
        win = {
          relative = "win",
        },
      }, -- for default options, refer to the configuration section for custom setup.
    },
    require('misc._snacks'),
    {
      "folke/flash.nvim",
      event = "VeryLazy",
      opts = {
        search = {
          multi_window = false,
          exclude = {
            "notify",
            "cmp_menu",
            "noice",
            "flash_prompt",
            "Outline",
            "NvimTree",
            function(win)
              return not vim.api.nvim_win_get_config(win).focusable
            end,
          },
        },
        modes = {
          search = {
            enabled = true,
          },
        },
      },
      keys = {
        { "gs", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
        { "gS", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      },
    },
    {
      'stevearc/quicker.nvim',
      ft = "qf",
      ---@module "quicker"
      opts = {},
    },
    { 'onsails/lspkind.nvim' },                                       -- vscode-like pictograms
    {
      "obsidian-nvim/obsidian.nvim",
      version = "*",
      lazy = true,
      ft = "markdown",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        local is_directory = require('utils').is_directory
        local workspaces = {
          { name = "notes",   path = "~/Desktop/knowledge" },
          { name = "work",    path = "~/Desktop/osec_io/knowledge/notes" },
          { name = "general", path = "~/Documents/Obsidian Vault" },
        }
        for i = #workspaces, 1, -1 do
          if not is_directory(workspaces[i].path) then
            table.remove(workspaces, i)
          end
        end
        if #workspaces > 0 then
          require("obsidian").setup({
            workspaces = workspaces,
            legacy_commands = false,
            ui = { enable = false },
            completion = {
              nvim_cmp = false,
              blink = true,
            },
          })
        end
      end,
    },
    {
      "folke/persistence.nvim",
      event = "BufReadPre", -- this will only start session saving when an actual file was opened
      opts = {},
    },
    {                                                                 -- A high-performance color highlighter for Neovim
      "norcalli/nvim-colorizer.lua",
      event = { "BufReadPost", "BufNewFile" },
      config = function()
        require('colorizer').setup({
          '*';
          '!lazy';
          '!notify';
          '!Outline';
        })
      end,
    },
    {                                                                 -- persistent bookmarks: hard disk of your thoughts
      "LintaoAmons/bookmarks.nvim",
      event = "VeryLazy",
      dependencies = {
        { "kkharji/sqlite.lua" },
        { "nvim-telescope/telescope.nvim" },
      },
    },
    {
      "yetone/avante.nvim",
      lazy = false,
      version = false,
      opts = {
        input = {
          provider = "snacks",
        },
        provider = "gemini",
        providers = {
          openai = { model = "gpt-5.2", },
          gemini = { model = "gemini-3-pro-preview", },
          claude = { model = "claude-sonnet-4-6", },
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
        windows = {
          sidebar_header = {
            rounded = false,
          }
        },
      },
      build = "make",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-tree/nvim-web-devicons",
      },
    },
    {
      "OXY2DEV/markview.nvim",
      lazy = false,
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
      }
    },
  },
  opts
)
