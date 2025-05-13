require('bookmarks').setup({
  -- Bookmarks sign configurations
  signs = {
    -- Sign mark icon and color in the gutter
    mark = {
      color = vim.g.colors.alt_fg,
      line_bg = "",
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
  },
  picker = {
    -- telescope entry display generation logic
    entry_display = function(bookmark, bookmarks)
      -- Calculate widths from all bookmarks
      local max_name = 15 -- minimum width
      local max_filename = 20 -- minimum width

      for _, bm in ipairs(bookmarks) do
        max_name = math.max(max_name, #bm.name)
        local filename = vim.fn.fnamemodify(bm.location.path, ":t")
        max_filename = math.max(max_filename, #filename)
      end

      -- Apply maximum constraints
      max_name = math.min(max_name, 100)
      max_filename = math.min(max_filename, 30)

      -- Format current bookmark entry
      local name = bookmark.name
      local filename = vim.fn.fnamemodify(bookmark.location.path, ":t")

      -- Pad or truncate name
      if #name > max_name then
        name = name:sub(1, max_name - 2) .. ".."
      else
        name = name .. string.rep(" ", max_name - #name)
      end

      -- Pad or truncate filename
      if #filename > max_filename then
        filename = filename:sub(1, max_filename - 2) .. ".."
      else
        filename = filename .. string.rep(" ", max_filename - #filename)
      end

      return string.format("%s │ %s", name, filename)
    end,
  },
})
