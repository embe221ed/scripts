--------------------------------------------------------------------------------
-- ui/colors.lua — committed shim over the generated colour mapping.
--
-- interdotensional generates the real mapping into the gitignored sibling
-- `colors.generated.lua`. When that file is present it wins verbatim; when it is
-- not, the fallback below does the same job and tolerates a partial palette.
--
-- This module MUST always return a table carrying `initialize_colors`: five call
-- sites call `require('ui.colors').initialize_colors(palette)` with no guard —
--
--   ui/schemes/_catppuccin.lua:23   ui/schemes/_gruvbox-material.lua:15
--   ui/schemes/_onedark.lua:8       ui/schemes/_tokyonight.lua:38
--   ui/schemes/_nord.lua:48
--
-- so a shim that returned an empty table would convert "no generator" from a
-- cosmetic downgrade into a hard error inside the colorscheme's config
-- callback, and leave vim.g.colors unset for lualine and bufferline.
--------------------------------------------------------------------------------

--- See the twin helper in lua/globals.lua for why this is loadfile and not
--- require. Duplicated on purpose: globals.lua is init.lua's first require and
--- must not depend on any other module.
---@return boolean ok, any result_or_error
local function load_sibling(name)
  local source = debug.getinfo(1, "S").source
  if source:sub(1, 1) ~= "@" then
    return false, "ui/colors.lua was not loaded from a file"
  end
  local dir = source:sub(2):match("^(.*)[/\\][^/\\]+$")
  if not dir then
    return false, "could not derive a directory from " .. source
  end
  local chunk, load_err = loadfile(dir .. "/" .. name)
  if not chunk then
    return false, load_err
  end
  return pcall(chunk)
end

local M = {}

-- vim.g.colors key  ->  catppuccin-shaped palette key. This is exactly the
-- mapping the generated file performs; it is duplicated here so the fallback is
-- not a different theme, just the same theme without the generator.
local KEYS = {
  bg = "base", fg = "text", alt_bg = "mantle", alt_fg = "surface2",
  dark_bg = "crust", light_bg = "surface0",
  red = "red", sky = "sky", teal = "teal", blue = "blue", pink = "pink",
  green = "green", purple = "mauve", orange = "peach", yellow = "yellow",
  accent = "pink", comment = "overlay0",
}

--- Map a colorscheme palette onto vim.g.colors.
---
--- The five callers pass five differently-shaped palettes (catppuccin, nord,
--- tokyonight, onedark, gruvbox-material), so a missing key is normal, not a
--- bug. Anything absent falls back to the seed palette globals.lua installed,
--- which means every key in vim.g.colors is always a string — lualine.lua:1 and
--- bufferline.lua:7-15 index it at file scope with no guard.
function M.initialize_colors(palette)
  if type(palette) ~= "table" then palette = {} end
  local seed = type(vim.g.colors) == "table" and vim.g.colors or {}
  local out = { none = "NONE" }
  for name, key in pairs(KEYS) do
    local v = palette[key]
    if type(v) ~= "string" then v = seed[name] end
    out[name] = v or "NONE"
  end
  vim.g.colors = out
end

local ok, generated = load_sibling("colors.generated.lua")
if ok and type(generated) == "table" and type(generated.initialize_colors) == "function" then
  return generated
end
return M
