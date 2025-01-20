-- custom configuration for the render-markdown.nvim plugin

require('render-markdown').setup({
  file_types = { 'markdown', 'norg', 'Avante' },
  heading = {
    enabled = true,
    sign = true,
    position = 'overlay',
    icons = { '󰼏 ', '󰼐 ', '󰼑 ', '󰼒 ', '󰼓 ', '󰼔 ' },
    signs = { '󰫎 ' },
    width = 'full',
    left_pad = 1,
    right_pad = 1,
    min_width = 0,
    border = false,
    border_prefix = false,
    above = '▄',
    below = '▀',
    backgrounds = {
      'RenderMarkdownH1Bg',
      'RenderMarkdownH2Bg',
      'RenderMarkdownH3Bg',
      'RenderMarkdownH4Bg',
      'RenderMarkdownH5Bg',
      'RenderMarkdownH6Bg'
    },
    foregrounds = {
      'RenderMarkdownH1',
      'RenderMarkdownH2',
      'RenderMarkdownH3',
      'RenderMarkdownH4',
      'RenderMarkdownH5',
      'RenderMarkdownH6'
    },
  },
  code = {
    enabled = true,
    sign = true,
    style = 'full',
    position = 'left',
    disable_background = { 'diff' },
    width = 'full',
    left_pad = 1,
    right_pad = 1,
    min_width = 0,
    border = 'thin',
    above = '▄',
    below = '▀',
    highlight = 'RenderMarkdownCode',
    highlight_inline = 'RenderMarkdownCodeInline',
  },
  bullet = {
    -- Turn on / off list bullet rendering
    enabled = true,
    -- Replaces '-'|'+'|'*' of 'list_item'
    -- How deeply nested the list is determines the 'level'
    -- The 'level' is used to index into the array using a cycle
    -- If the item is a 'checkbox' a conceal is used to hide the bullet instead
    icons = { '', '', '', '' },
    -- Padding to add to the left of bullet point
    left_pad = 0,
    -- Padding to add to the right of bullet point
    right_pad = 1,
    -- Highlight for the bullet icon
    highlight = 'RenderMarkdownBullet',
  },
})

