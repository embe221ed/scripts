-- OneDarkPro theme
local utils = require('utils')
local colorscheme = vim.g.colorscheme.name
local current_theme = vim.g.colorscheme.theme

local palette = utils.get_palette(colorscheme, current_theme)
require("onedarkpro").setup({ })
require('ui.colors').initialize_colors(palette)
