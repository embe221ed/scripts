return {
  "folke/snacks.nvim",
  opts = {
    input = {},
    zen = {},
    words = { enabled = true, notify_jump = true },
    notifier = {
      enabled = true,
    },
    image = { enabled = true },
    profiler = {},
    indent = {
      indent = { char = "▏" },
      scope = { char = "▏" },
    },
    dashboard = require('ui.components.dashboard'),
    picker = {
      matcher = { frecency = true },
      layout = {
        preset = function()
          return vim.o.columns >= 120 and "default" or "vertical"
        end,
        layout = {
          backdrop = vim.g.neovide or vim.g.border == "none",
        },
      },
      sources = {
        explorer = {
          layout = { preset = "default", preview = true },
          auto_close = true,
        }
      },
    },
  },
}
