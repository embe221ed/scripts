require('bookmarks').setup({
  -- Bookmarks sign configurations
  signs = {
    -- Sign mark icon and color in the gutter
    mark = {
      color = vim.g.colors.alt_fg,
      line_bg = vim.g.colors.alt_bg,
    },
    desc_format = function(bookmark)
      ---@cast bookmark Bookmarks.Node
      return "#" .. bookmark.order .. ": " .. bookmark.name
    end,
  },
  treeview = {
    highlights = {
      active_list = {
        bg = "",
        fg = vim.g.colors.orange,
        bold = true,
      },
    }
  }
})
