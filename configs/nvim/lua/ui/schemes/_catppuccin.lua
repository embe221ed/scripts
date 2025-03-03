-- Catppuccin theme
local utils = require('utils')
local colorscheme = vim.g.colorscheme.name
local current_theme = vim.g.colorscheme.theme

local color_overrides = {
  latte = {
    text = "#6c6f85",
    peach = "#f28d5e"
  },
  frappe = {
    lavender = "#b4b5ee",
  }
}
local palette = utils.get_palette(colorscheme, current_theme)

if color_overrides[current_theme] then
  for key, value in pairs(color_overrides[current_theme]) do
    palette[key] = value
  end
end

require('ui.colors').initialize_colors(palette)
local colors = vim.g.colors

-- local utils = require('catppuccin.utils.colors')
require('catppuccin').setup({
  flavour = current_theme, -- latte, frappe, macchiato, mocha
  transparent_background = false, -- disables setting the background color.
  show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
  term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
  dim_inactive = {
    enabled = false, -- dims the background color of inactive window
    shade = "dark",
    percentage = 0.15, -- percentage of the shade to apply to the inactive window
  },
  no_italic = false, -- Force no italic
  no_bold = false, -- Force no bold
  no_underline = false, -- Force no underline
  styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
    comments = { "italic" }, -- Change the style of comments
    conditionals = {},
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
    -- miscs = {}, -- Uncomment to turn off hard-coded styles
  },
  color_overrides = color_overrides,
  custom_highlights = {
    WinSeparator                = { fg = palette.surface0 },
    TabLineSel                  = { bg = colors.accent },
    FloatBorder                 = { fg = colors.alt_fg, bg = colors.base, style = { "bold" } },
    NormalFloat                 = { bg = colors.none },
    PmenuSel                    = { bg = colors.alt_fg, style = {} },
    -- PmenuSbar                   = { bg = utils.darken(palette.surface0, 0.8, palette.crust), },

    BlinkCmpLabelDescription    = { fg = colors.comment, style = { "italic" } },

    NoicePopup                  = { bg = palette.crust },
    NoiceCmdlinePopupBorder     = { fg = colors.alt_fg, style = { "bold" } },

    StatusLine                  = { fg = colors.bg, bg = colors.bg },
    StatusLineNC                = { fg = colors.bg, bg = colors.bg },

    CursorLineNr                = { fg = colors.accent, style = { "bold" } },

    OutlineCurrent              = { fg = colors.orange, bg = "", style = { "bold" } },

    TelescopeTitle              = { fg = palette.cyan },
    TelescopeBorder             = { fg = colors.alt_fg, style = { "bold" } },

    AvanteInlineHint            = { fg = palette.overlay2, style = { "italic" } },

    NvimTreeFolderName          = { fg = colors.orange },
    NvimTreeFolderIcon          = { fg = colors.orange },
    NvimTreeOpenedFolderName    = { fg = colors.orange },
    NvimTreeEmptyFolderName     = { fg = colors.orange },
    NvimTreeIndentMarker        = { fg = colors.comment },
    NvimTreeWinSeparator        = { fg = colors.alt_bg, bg = colors.alt_bg, },
    NvimTreeRootFolder          = { fg = colors.orange, style = { "bold" } },
    NvimTreeSymlink             = { fg = colors.pink },
    NvimTreeGitDirty            = { fg = colors.yellow },
    NvimTreeGitNew              = { fg = colors.blue },
    NvimTreeGitDeleted          = { fg = colors.red },
    NvimTreeSpecialFile         = { fg = palette.flamingo },
    NvimTreeImageFile           = { fg = colors.fg },
    NvimTreeOpenedFile          = { fg = colors.pink },
    NvimTreeNormal              = { bg = colors.alt_bg },
    NvimTreeNormalNC            = { bg = colors.alt_bg },
    NvimTreeExecFile            = { fg = colors.red },
    NvimTreeOpenedHL            = { fg = palette.surface2 },
    NvimTreeStatusLine          = { fg = colors.alt_bg, bg = colors.alt_bg },
    NvimTreeStatusLineNC        = { fg = colors.alt_bg, bg = colors.alt_bg },

    TreesitterContextBottom     = { sp = colors.alt_fg, style = { "underline" } },

    ["@parameter.readonly"]     = { fg = palette.maroon, style = { "italic" } },
    ["@parameter.modification"] = { fg = palette.maroon, style = { "italic" } },

  }, -- Override highlight groups
  default_integrations = false,
  integrations = {
    cmp = true,
    blink_cmp = true,
    gitsigns = true,
    nvimtree = false,
    treesitter = true,
    notify = true,
    mini = {
      enabled = true,
      indentscope_color = "",
    },
    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  },
})
