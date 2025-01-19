local function _is_dark()
  local out = os.execute("/opt/scripts/utils/determine_system.sh") / 256
  -- not Darwin (MacOS), early return
  if out ~= 1 then return os.getenv("DISPLAY_MODE") == "Dark" end
  local result = os.execute("defaults read -g AppleInterfaceStyle &> /dev/null") / 256
  if result == 1 then
    return false
  else
    return true
  end
end

local _dark_colorscheme = 'catppuccin'
local _light_colorscheme = 'catppuccin'
local _colorscheme = _is_dark() and _dark_colorscheme or _light_colorscheme

local function _get_tokyonight_day_palette(palette)
  local opts = {}
  return palette(opts)
end

local function determine_theme(colorscheme)
  local dark, light
  if colorscheme == 'catppuccin' then
    dark, light = "frappe", "latte"
  elseif colorscheme == 'tokyonight' then
    dark, light = "storm", "day"
  end
  if _is_dark() then return dark else return light end
end

local function get_palette(colorscheme, theme)
  local palette
  if colorscheme == 'catppuccin' then
    palette = require("catppuccin.palettes").get_palette(theme)
  elseif colorscheme == 'tokyonight' then
    palette = require('tokyonight.colors.' .. theme)
    if theme == "day" then return _get_tokyonight_day_palette(palette) end
  end
  return palette
end

--- prepare the globals table

local globals = {
  colorscheme = _colorscheme,
  current_theme = determine_theme(_colorscheme),
  get_palette = get_palette,
  generate_desc = function(desc)
    return desc .. string.rep(' ' , 40)
  end
}

return globals
