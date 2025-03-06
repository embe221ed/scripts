local padding = " "
if vim.g.symbol_font then padding = "  " end

require('nvim-tree').setup({
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
    highlight_opened_files = "all",
  },
  actions = {
    open_file = {
      resize_window = false,
    }
  },
})
