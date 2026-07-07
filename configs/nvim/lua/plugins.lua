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

-- optional startup profiling: `PROF=1 nvim`  (snacks.profiler)
if vim.env.PROF then
  vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy/snacks.nvim")
  require("snacks.profiler").startup({ startup = { event = "VimEnter" } })
end

return require("lazy").setup(
  {
    {
      "nvim-tree/nvim-tree.lua",                                      -- filesystem navigation
      dependencies = { "nvim-tree/nvim-web-devicons" },               -- filesystem icons
      cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile", "NvimTreeOpen" },
      keys = {
        { "<C-n>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
      },
      config = function() require('ui.components.nvimtree') end,
    },
    vim.g.colorscheme.plugin(),                                       -- load desired colorscheme
    {
      "nvim-treesitter/nvim-treesitter",                              -- tree-sitter functionality and highlighting
      build = ":TSUpdate",
      config = function()
        require('nvim-treesitter').install({ "c", "cpp", "lua", "rust", "python", "javascript", "markdown", "markdown_inline" })
        require('nvim-treesitter').setup {}
        -- main branch: highlighting is opt-in per buffer via vim.treesitter.start()
        vim.api.nvim_create_autocmd('FileType', {
          callback = function(ev)
            if vim.tbl_contains({ "latex", "dockerfile" }, ev.match) then return end
            pcall(vim.treesitter.start, ev.buf)
          end,
        })
      end,
    },
    {                                                                 -- pin the current context at the top of the screen
      "nvim-treesitter/nvim-treesitter-context",
      dependencies = { 'nvim-treesitter/nvim-treesitter' },
      config = function()
        require('treesitter-context').setup {
          enable = true,
          max_lines = 3,
          min_window_height = 0,
          line_numbers = true,
          multiline_threshold = 1,
          trim_scope = 'outer',
          mode = 'cursor',
          zindex = 20,
          on_attach = nil,
        }
      end,
    },
    {
      "nvim-lualine/lualine.nvim",                                    -- status line
      dependencies = { "nvim-tree/nvim-web-devicons", opt = true },   -- filesystem icons
    },
    {
      "luukvbaal/statuscol.nvim",                                     -- extended status column
    },
    {
      "lewis6991/gitsigns.nvim",                                      -- git signs, blame, hunks
      event = { "BufReadPre", "BufNewFile" },
      opts = {
        current_line_blame = true,
        current_line_blame_opts = {
          delay = 300,
          virt_text_pos = "eol",
          ignore_whitespace = false,
        },
        current_line_blame_formatter = function(_, blame, _)
          local function rel(t)
            t = tonumber(t) or os.time()
            local d = math.max(os.time() - t, 0)
            if d < 60 then return "just now" end
            local steps = { { 60, "m" }, { 60, "h" }, { 24, "d" }, { 7, "w" }, { 4.34, "mo" }, { 12, "y" } }
            local v, unit = d, "s"
            for _, step in ipairs(steps) do
              if v < step[1] then break end
              v, unit = v / step[1], step[2]
            end
            return string.format("%d%s ago", math.floor(v), unit)
          end
          -- middot · separator between code and blame; text is italic (see _gruvbox-material.lua)
          if blame.author == "Not Committed Yet" then
            return { { "  ·  ", "GitSignsCurrentLineBlameSep" }, { "Not committed yet", "GitSignsCurrentLineBlame" } }
          end
          local text = string.format("%s · %s · %s", blame.author, rel(blame.author_time), blame.summary)
          return {
            { "  ·  ", "GitSignsCurrentLineBlameSep" },
            { text,   "GitSignsCurrentLineBlame" },
          }
        end,
        on_attach = function(bufnr)
          local gs = require('gitsigns')
          local function gmap(l, r, desc)
            vim.keymap.set('n', l, r, { buffer = bufnr, desc = desc })
          end
          -- hunk motion on ]h / [h (NOT ]c/[c: those are native diff-mode motions)
          gmap(']h', function() gs.nav_hunk('next') end, "Next hunk")
          gmap('[h', function() gs.nav_hunk('prev') end, "Prev hunk")
          gmap('<space>hp', gs.preview_hunk_inline,          "Preview hunk")
          gmap('<space>hb', function() gs.blame_line({ full = true }) end, "Blame line")
          gmap('<space>hd', gs.diffthis,                     "Diff this")
          gmap('<space>hD', function() gs.diffthis('~') end, "Diff this (~)")
          gmap('<space>hs', gs.stage_hunk,                   "Stage hunk")
          gmap('<space>hr', gs.reset_hunk,                   "Reset hunk")
          gmap('<space>ht', gs.toggle_current_line_blame,    "Toggle line blame")
          gmap('<space>hw', gs.toggle_word_diff,             "Toggle word diff")
          gmap('<space>hx', gs.toggle_deleted,               "Toggle deleted")
        end,
      },
    },
    "neovim/nvim-lspconfig",                                          -- configurations for nvim LSP
    {
      "mfussenegger/nvim-dap",                                        -- Debug Adapter Protocol client (lazy: keys/cmd)
      dependencies = {
        { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      },
      cmd = { "DapContinue", "DapToggleBreakpoint", "DapNew" },
      keys = {
        { "<F5>",      function() require('dap').continue() end,          desc = "DAP continue" },
        { "<F10>",     function() require('dap').step_over() end,         desc = "DAP step over" },
        { "<F11>",     function() require('dap').step_into() end,         desc = "DAP step into" },
        { "<F12>",     function() require('dap').step_out() end,          desc = "DAP step out" },
        { "<space>db", function() require('dap').toggle_breakpoint() end, desc = "DAP toggle breakpoint" },
        { "<space>du", function() require('dapui').toggle() end,          desc = "DAP toggle UI" },
      },
      config = function() require('editor.dev.dap') end,
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
    {
      "HiPhish/rainbow-delimiters.nvim",                              -- rainbow parens
      config = function()
        require('rainbow-delimiters.setup').setup({})
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
      "folke/todo-comments.nvim",                                     -- AUDIT/FINDING taxonomy + navigation
      dependencies = { "nvim-lua/plenary.nvim" },
      event = { "BufReadPost", "BufNewFile" },
      cmd = { "TodoTrouble", "TodoQuickFix", "TodoLocList" },
      keys = {
        { "]t", function() require('todo-comments').jump_next() end, desc = "Next todo / finding" },
        { "[t", function() require('todo-comments').jump_prev() end, desc = "Prev todo / finding" },
        { "<space>af", "<cmd>Trouble todo toggle filter={tag={AUDIT,SECURITY,FINDING,BUG,ISSUE}}<cr>", desc = "Audit findings (Trouble)" },
        { "<space>aq", "<cmd>TodoQuickFix<cr>", desc = "Findings -> quickfix" },
        { "<space>at", function() Snacks.picker.grep({ search = "AUDIT|SECURITY|FINDING|BUG|ISSUE", regex = true }) end, desc = "Findings (grep)" },
      },
      opts = function()
        return {
          keywords = {
            AUDIT       = { icon = "󰒃 ", color = "audit", alt = { "SECURITY" } },
            QUESTION    = { icon = " ", color = "question", alt = { "Q", "ASK" } },
            FINDING     = { icon = "󰈸 ", color = "error", alt = { "BUG", "ISSUE" } },
            SUGGESTION  = { icon = " ", color = "sugg", alt = { "NIT", "SUG" } },
            NOTE        = { icon = " ", color = "hint", alt = { "INFO" } },
            IDEA        = { icon = " ", color = "idea" },
          },
          colors = {
            idea      = { vim.g.colors.yellow },
            audit     = { vim.g.colors.purple },
            question  = { vim.g.colors.sky },
            sugg      = { vim.g.colors.teal },
          },
        }
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
      cmd = { "G", "Git", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite", "Gedit", "GBrowse", "Gclog", "Gllog" },
      dependencies = { "tpope/vim-rhubarb" },                         -- :GBrowse
    },
    {
      "MagicDuck/grug-far.nvim",                                      -- search / replace as a buffer (audit sink-hunting)
      cmd = "GrugFar",
      opts = { engines = { astgrep = { path = "ast-grep" } } },
      keys = {
        { "<space>sR", function() require('grug-far').open({ transient = true }) end, desc = "Search / replace (grug-far)" },
        { "<space>sR", mode = "x", function() require('grug-far').with_visual_selection({ transient = true }) end, desc = "Search / replace selection" },
      },
    },
    {
      'nmac427/guess-indent.nvim',                                    -- guess the indent type in the current buffer
      event = { "BufReadPost", "BufNewFile" },
      opts = {
        auto_cmd = true,
        override_editorconfig = false,
        filetype_exclude = { "netrw", "tutor" },
        buftype_exclude = { "help", "nofile", "terminal", "prompt" },
      },
    },
    {
      "folke/noice.nvim",
      event = "VeryLazy",
      dependencies = {
        "MunifTanjim/nui.nvim",
      },
      config = function() require('ui.components.noice') end,
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
        jump = { nohlsearch = true },
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
            enabled = false,
          },
        },
      },
      keys = {
        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
        { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
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
    { 'onsails/lspkind.nvim', lazy = true },                          -- vscode-like pictograms
    {
      "folke/which-key.nvim",                                         -- keymap discoverability
      event = "VeryLazy",
      opts = {
        preset = "helix",
        spec = {
          { "gb", group = "buffer" },
          { "<space>w", group = "workspace" },
          { "<space>t", group = "treesitter" },
          { "<space>u", group = "ui toggles" },
          { "<space>d", group = "diagnostics / dap" },
          { "<space>b", group = "bookmarks" },
          { "<space>a", group = "audit / findings" },
          { "<space>h", group = "git hunks" },
          { "<space>f", group = "find" },
          { "<space>s", group = "search" },
          { "<space>p", group = "profiler" },
        },
      },
    },
    {
      "mfussenegger/nvim-lint",                                       -- external linters as diagnostics
      event = { "BufReadPost", "BufNewFile" },
      config = function()
        local lint = require('lint')
        lint.linters_by_ft = {
          solidity = { 'solhint' },
        }
        local grp = vim.api.nvim_create_augroup("nvim_lint", { clear = true })
        vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
          group = grp,
          callback = function()
            -- only run linters whose executable is actually on PATH
            local names = lint.linters_by_ft[vim.bo.filetype] or {}
            local runnable = {}
            for _, name in ipairs(names) do
              local l = lint.linters[name]
              local cmd = type(l) == "table" and l.cmd or name
              if vim.fn.executable(cmd) == 1 then
                table.insert(runnable, name)
              end
            end
            if #runnable > 0 then require('lint').try_lint(runnable) end
          end,
        })
      end,
    },
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
      "catgoose/nvim-colorizer.lua",
      event = { "BufReadPost", "BufNewFile" },
      config = function()
        require('colorizer').setup({
          filetypes = { '*', '!lazy', '!notify', '!Outline' },
          user_default_options = {
            css = true,
            css_fn = true,
            tailwind = true,
            AARRGGBB = true,
            RRGGBBAA = true,
          },
        })
      end,
    },
    {                                                                 -- persistent bookmarks: hard disk of your thoughts
      "LintaoAmons/bookmarks.nvim",
      event = "VeryLazy",
      dependencies = {
        { "kkharji/sqlite.lua" },
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
