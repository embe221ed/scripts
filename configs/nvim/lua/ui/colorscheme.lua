local colorscheme = vim.g.colorscheme.name

require(string.format('ui.schemes._%s', colorscheme))

vim.cmd.colorscheme(colorscheme)
