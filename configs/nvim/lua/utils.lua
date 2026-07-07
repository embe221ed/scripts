local function _get_tokyonight_day_palette(palette)
  local opts = {}
  return palette(opts)
end

local utils = {}

function utils.is_dark()
  local out = os.execute("/opt/scripts/utils/determine_system.sh") / 256
  -- not Darwin (MacOS), early return
  if out ~= 1 then return os.getenv("DISPLAY_MODE") ~= "Light" end
  local result = os.execute("defaults read -g AppleInterfaceStyle &> /dev/null") / 256
  if result == 1 then
    return false
  else
    return true
  end
end

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
