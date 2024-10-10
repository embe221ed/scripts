local _colorscheme = 'tokyonight'

local function determine_theme(colorscheme)
  local dark, light
  if colorscheme == 'catppuccin' then
    dark, light = "frappe", "latte"
  elseif colorscheme == 'tokyonight' then
    dark, light = "storm", "day"
  end
  local out = os.execute("/opt/scripts/utils/determine_system.sh") / 256
  -- not Darwin (MacOS), early return
  if out ~= 1 then return dark end
  local result = os.execute("defaults read -g AppleInterfaceStyle &> /dev/null") / 256
  if result == 1 then
    return light
  else
    return dark
  end
end

local function get_palette(colorscheme, theme)
  local palette
  if colorscheme == 'catppuccin' then
    palette = require("catppuccin.palettes").get_palette(theme)
  elseif colorscheme == 'tokyonight' then
    palette = require('tokyonight.colors.' .. theme)
    if theme == "day" then return palette({}) end
  end
  return palette
end

local globals = {
  colorscheme = _colorscheme,
  current_theme = determine_theme(_colorscheme),
  get_palette = get_palette,
  generate_desc = function(desc)
    return desc .. string.rep(' ' , 40)
  end
}

return globals
