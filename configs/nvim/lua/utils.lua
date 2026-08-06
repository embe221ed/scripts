local function _get_tokyonight_day_palette(palette)
  local opts = {}
  return palette(opts)
end

local utils = {}

function utils.is_directory(path)
  local expanded_path = vim.fn.expand(path)
  local stat = vim.uv.fs_stat(expanded_path)
  return stat and stat.type == "directory"
end

function utils.get_palette(colorscheme, theme)
  local palette
  if colorscheme == 'catppuccin' then
    palette = require("catppuccin.palettes").get_palette(theme)
  elseif colorscheme == 'tokyonight' then
    palette = require('tokyonight.colors.' .. theme)
    if theme == "day" then return _get_tokyonight_day_palette(palette) end
  elseif colorscheme == "nord" then
    palette = require('nord.colors').palette
  elseif colorscheme == "onedark" then
    palette = require('onedarkpro.helpers').get_colors(theme)
  else
    error(string.format("utils.get_palette for colorscheme=%s, theme=%s not defined", colorscheme, theme))
    return {}
  end
  return palette
end

function utils.generate_desc(desc)
  return desc .. string.rep(' ' , 40)
end

function utils.ternary(cond, t, f)
  if cond then return t else return f end
end


return utils
