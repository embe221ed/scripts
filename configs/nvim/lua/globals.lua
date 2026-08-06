--------------------------------------------------------------------------------
-- globals.lua — committed shim over the generated globals.
--
-- init.lua's FIRST require. Until now this file was a symlink into another
-- repository's gitignored output/ directory, so a clean clone died here, before
-- drawing a frame.
--
-- interdotensional generates the real values into the gitignored sibling
-- `globals.generated.lua` (see `interdot link`). That file is OPTIONAL: every
-- key the rest of the config indexes without a guard has a default here, so a
-- machine with no generator — a fresh clone, the dev container, CI — starts
-- unthemed rather than erroring.
--
-- Whether the generated file was found is recorded in `vim.g.interdot_generated`
-- (`:lua =vim.g.interdot_generated`); `install.sh --check` reports it too.
--------------------------------------------------------------------------------

--- Load a Lua file sitting next to this one, if it exists.
---
--- Deliberately NOT `require`: Lua rewrites dots to path separators, so
--- `require('globals.generated')` looks for lua/globals/generated.lua — not the
--- lua/globals.generated.lua that `interdot link` actually creates. Locating the
--- file from debug.getinfo keeps this correct wherever the repo is cloned, and
--- whether or not ~/.config/nvim is itself a symlink into it.
---
--- Returns `false, err` when the file is absent, is a dangling symlink (the
--- generator's tree moved), or raises while running. Never throws.
---@return boolean ok, any result_or_error
local function load_sibling(name)
  local source = debug.getinfo(1, "S").source
  if source:sub(1, 1) ~= "@" then
    return false, "globals.lua was not loaded from a file"
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

--------------------------------------------------------------------------------
-- fallback palette
--
-- Overwritten wholesale by ui.colors.initialize_colors() as soon as a real
-- colorscheme loads. It exists because lua/ui/components/lualine.lua:1 and
-- lua/ui/components/bufferline.lua:7-15 read vim.g.colors at file scope, with no
-- guard: without a seed, "no colorscheme plugin installed yet" is a hard error
-- at init.lua:20, not a cosmetic downgrade.
--
-- Plain xterm-256 hexes on purpose — a neutral stand-in, not a competing theme.
--------------------------------------------------------------------------------
local fallback_colors = {
  dark = {
    bg = "#1c1c1c", fg = "#d0d0d0",
    alt_bg = "#262626", alt_fg = "#8a8a8a",
    dark_bg = "#121212", light_bg = "#303030",

    red = "#d75f5f", sky = "#5fafd7", teal = "#5fafaf", blue = "#5f87d7",
    pink = "#d787af", green = "#87af5f", purple = "#af87d7",
    orange = "#d78700", yellow = "#d7af5f",

    accent = "#5f87d7", comment = "#6c6c6c",
    none = "NONE",
  },
  light = {
    bg = "#eeeeee", fg = "#303030",
    alt_bg = "#e4e4e4", alt_fg = "#767676",
    dark_bg = "#dadada", light_bg = "#fafafa",

    red = "#af0000", sky = "#0087af", teal = "#008787", blue = "#005faf",
    pink = "#af005f", green = "#5f8700", purple = "#8700af",
    orange = "#af5f00", yellow = "#af8700",

    accent = "#005faf", comment = "#8a8a8a",
    none = "NONE",
  },
}

--------------------------------------------------------------------------------
-- defaults
--
-- One entry for every top-level key output/nvim/globals.lua sets, plus
-- `colors`. Anything the generated file also sets is overwritten below; what it
-- omits survives.
--------------------------------------------------------------------------------
local defaults = {
  -- consumed by the vimtex plugin, never indexed by this config
  vimtex_view_method = vim.fn.has("mac") == 1 and "skim" or "zathura",

  -- `if vim.g.symbol_font then` — truthiness only, but keep the type honest
  symbol_font = false,

  -- compared to "none" and passed straight to plugin opts as a border value
  border = "none",

  -- passed straight to plugin opts; nil would silently disable pseudo-transparency
  winblend = 0,

  indentLine_fileTypeExclude = {
    "lspinfo", "packer", "checkhealth", "dashboard",
    "help", "man", "diff", "git", "",
  },

  -- indexed unguarded: opts.lua:44,46 · nvimtree.lua:25,26 · plugins.lua:228.
  -- opts.lua feeds these to 'fillchars', which rejects anything that is not
  -- exactly ONE character — an empty string there is E1511, not a blank glyph.
  -- U+25B8/U+25BE (small triangles right/down) rather than the generator's Nerd
  -- Font chevrons, so the fallback does not assume a patched font is installed.
  -- Written as \u{} escapes (LuaJIT supports them) so the two values cannot be
  -- silently mangled by an editor, a diff or a copy-paste.
  symbols = { expand = "\u{25B8}", collapse = "\u{25BE}" },

  -- pairs()'d unguarded by ui/schemes/_gruvbox-material.lua:11 — nil is a hard
  -- error there ("bad argument #1 to 'pairs'"), {} is a no-op
  catppuccin_overrides = {},

  -- indexed two levels deep: lsp.lua:61 · noice.lua:50
  lsp = {
    doc = { border = false },
    diagnostic = { border = "solid" },
  },

  -- indexed unguarded: lsp.lua:8,14
  goto_preview = {
    border = { " ", " ", " ", " ", " ", " ", " ", " " },
    title_length = 60,
  },

  -- indexed unguarded: opts.lua:23 · lualine.lua:7
  statusline = { laststatus = 3 },

  -- .name/.scheme/.theme/.vanilla indexed unguarded by ui/colorscheme.lua and
  -- every ui/schemes/_*.lua; .plugin() is CALLED unguarded at plugins.lua:40 and
  -- must return a valid lazy.nvim spec
  colorscheme = {
    name = "catppuccin",
    scheme = "catppuccin",
    theme = vim.o.background == "light" and "latte" or "mocha",
    vanilla = false,
    plugin = function()
      return {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
          -- pcall so that an uninstallable plugin, an offline machine or a
          -- palette that does not have the requested flavour leaves the
          -- fallback colours in place instead of aborting lazy's setup.
          local ok, err = pcall(require, "ui.colorscheme")
          if not ok then
            vim.notify(
              "colorscheme setup failed, staying unthemed: " .. tostring(err),
              vim.log.levels.WARN
            )
          end
        end,
      }
    end,
  },

  colors = fallback_colors[vim.o.background == "light" and "light" or "dark"],
}

for key, value in pairs(defaults) do
  vim.g[key] = value
end

--------------------------------------------------------------------------------
-- the generated values, when they are there
--------------------------------------------------------------------------------
local ok, err = load_sibling("globals.generated.lua")
vim.g.interdot_generated = ok
if not ok then
  -- Intentionally not vim.notify: on a machine without the generator this is
  -- the expected state, and a message on every startup is noise. The reason is
  -- kept where a human can find it.
  vim.g.interdot_generated_error = tostring(err)
end

--------------------------------------------------------------------------------
-- backfill
--
-- Guards against a future generated file emitting a PARTIAL table — e.g. a
-- `lsp` without `diagnostic`, which would put a nil back under an unguarded
-- two-level index. Reading vim.g.<x> yields a COPY, so a merged table has to be
-- assigned back; that is done only when something actually changed, so
-- vim.g.colorscheme (which carries a function) is not round-tripped through the
-- vimscript funcref conversion for nothing.
--------------------------------------------------------------------------------
local function backfill(key, template)
  local current = vim.g[key]
  if type(current) ~= "table" then
    vim.g[key] = template
    return
  end
  local changed = false
  for k, v in pairs(template) do
    if current[k] == nil then
      current[k] = v
      changed = true
    -- Recurse into maps only. `#v == 0` deliberately excludes list-shaped
    -- values such as goto_preview.border: a generated 4-element border is a
    -- legitimate border, and padding it back out to the default's 8 would
    -- silently change it.
    elseif type(v) == "table" and type(current[k]) == "table" and #v == 0 then
      for k2, v2 in pairs(v) do
        if current[k][k2] == nil then
          current[k][k2] = v2
          changed = true
        end
      end
    end
  end
  if changed then vim.g[key] = current end
end

for _, key in ipairs({ "symbols", "lsp", "goto_preview", "statusline", "colorscheme" }) do
  backfill(key, defaults[key])
end

-- scalars and the two tables that are consumed whole
if type(vim.g.border) ~= "string" then vim.g.border = defaults.border end
if type(vim.g.winblend) ~= "number" then vim.g.winblend = defaults.winblend end
if type(vim.g.catppuccin_overrides) ~= "table" then vim.g.catppuccin_overrides = {} end
if type(vim.g.colors) ~= "table" then vim.g.colors = defaults.colors end

-- Declared in `defaults` above but not indexed anywhere in this config. Applied
-- anyway so `vim.g` is deterministic and matches what the generator would have
-- set: `symbol_font` is read for truthiness only (nil and false behave
-- identically at all four call sites) — this just keeps the type honest, as its
-- own default's comment says; `vimtex_view_method` is consumed by the vimtex
-- plugin, and the default here is platform-aware where the generator hardcodes
-- "skim"; `indentLine_fileTypeExclude` is vestigial generator output.
if type(vim.g.symbol_font) ~= "boolean" then vim.g.symbol_font = defaults.symbol_font end
if type(vim.g.vimtex_view_method) ~= "string" then vim.g.vimtex_view_method = defaults.vimtex_view_method end
if type(vim.g.indentLine_fileTypeExclude) ~= "table" then vim.g.indentLine_fileTypeExclude = defaults.indentLine_fileTypeExclude end
