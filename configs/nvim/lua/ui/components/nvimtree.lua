local padding = " "
if vim.g.symbol_font then padding = "  " end

require('nvim-tree').setup({
  view = {
    adaptive_size = true,
    centralize_selection = false,
    width = 40,
    side = "left",
    preserve_window_proportions = true,
    number = false,
    relativenumber = false,
    signcolumn = "yes",
  },
  renderer = {
    icons = {
      padding = padding,
      git_placement = "signcolumn",
    },
    add_trailing = true,
    full_name = true,
    root_folder_label = function(path)
      return "" .. padding .. vim.fn.fnamemodify(path, ":t") .. "/"
    end,
    symlink_destination = false,
    indent_markers = {
      enable = true,
    },
    highlight_opened_files = "all",
  },
  actions = {
    open_file = {
      resize_window = false,
    }
  },
})
