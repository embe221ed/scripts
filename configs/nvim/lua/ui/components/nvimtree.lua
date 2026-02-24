local padding = " "
if vim.g.symbol_font then padding = "  " end

require('nvim-tree').setup({
  disable_netrw = true,
  view = {
    adaptive_size = true,
    centralize_selection = false,
    side = "left",
    width = 40,
    preserve_window_proportions = true,
    number = false,
    relativenumber = false,
    signcolumn = "yes",
  },
  renderer = {
    icons = {
      padding = padding,
      git_placement = "signcolumn",
      show = {
        folder = false,
      },
      glyphs = {
        folder = {
          arrow_closed = vim.g.symbols.expand,
          arrow_open = vim.g.symbols.collapse,
        },
      },
    },
    add_trailing = true,
    full_name = false,
    root_folder_label = function(path)
      return vim.fn.fnamemodify(path, ":t") .. "/"
    end,
    symlink_destination = false,
    indent_markers = {
      enable = true,
    },
    highlight_opened_files = "none",
  },
  actions = {
    open_file = {
      resize_window = false,
    }
  },
})

local api = vim.api
local nvim_tree_api = require("nvim-tree.api")
local Event = nvim_tree_api.events.Event

-- Subscribe to the TreeOpen event
nvim_tree_api.events.subscribe(
  Event.TreeOpen,
  function()
    local win = nvim_tree_api.tree.winid()

    if win then
      api.nvim_set_option_value("statuscolumn", "",       { scope = "local", win = win })
      api.nvim_set_option_value("statusline",   " ",      { scope = "local", win = win })
      api.nvim_set_option_value("fillchars",    "vert: ", { scope = "local", win = win })
    end
  end
)
