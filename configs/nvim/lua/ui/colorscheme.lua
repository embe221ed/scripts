local colorscheme = vim.g.colorscheme.name
local scheme = vim.g.colorscheme.scheme or colorscheme

require(string.format('ui.schemes._%s', scheme))

vim.cmd.colorscheme(colorscheme)
