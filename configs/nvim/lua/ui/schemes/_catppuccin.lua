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
    TabLineSel                  = { bg = palette.pink },
    FloatBorder                 = { fg = palette.surface1, bg = palette.base, style = { "bold" } },
    PmenuSel                    = { bg = palette.surface1, style = {} },
    -- PmenuSbar                   = { bg = utils.darken(palette.surface0, 0.8, palette.crust), },

    BlinkCmpLabelDescription    = { fg = palette.overlay0, style = { "italic" } },

    NoicePopup                  = { bg = palette.crust },
    NoiceCmdlinePopupBorder     = { fg = palette.surface1, style = { "bold" } },

    StatusLine                  = { fg = palette.base, bg = palette.base },
    StatusLineNC                = { fg = palette.base, bg = palette.base },

    CursorLineNr                = { fg = palette.pink, style = { "bold" } },

    OutlineCurrent              = { fg = palette.peach, bg = "", style = { "bold" } },

    TelescopeTitle              = { fg = palette.cyan },
    TelescopeBorder             = { fg = palette.surface1, style = { "bold" } },

    AvanteInlineHint            = { fg = palette.overlay2, style = { "italic" } },

    NvimTreeFolderName          = { fg = palette.peach },
    NvimTreeFolderIcon          = { fg = palette.peach },
    NvimTreeOpenedFolderName    = { fg = palette.peach },
    NvimTreeEmptyFolderName     = { fg = palette.peach },
    NvimTreeIndentMarker        = { fg = palette.overlay0 },
    NvimTreeWinSeparator        = { fg = palette.base, bg = palette.base, },
    NvimTreeRootFolder          = { fg = palette.peach, style = { "bold" } },
    NvimTreeSymlink             = { fg = palette.pink },
    NvimTreeGitDirty            = { fg = palette.yellow },
    NvimTreeGitNew              = { fg = palette.blue },
    NvimTreeGitDeleted          = { fg = palette.red },
    NvimTreeSpecialFile         = { fg = palette.flamingo },
    NvimTreeImageFile           = { fg = palette.text },
    NvimTreeOpenedFile          = { fg = palette.pink },
    NvimTreeNormal              = { bg = palette.mantle },
    NvimTreeExecFile            = { fg = palette.red },
    NvimTreeOpenedHL            = { fg = palette.surface2 },
    NvimTreeStatusLine          = { fg = palette.base, bg = palette.base },
    NvimTreeStatusLineNC        = { fg = palette.base, bg = palette.base },

    TreesitterContextBottom     = { sp = palette.surface1, style = { "underline" } },

    BufferlineOffsetTitleBase   = { fg = palette.pink, bg = palette.mantle },
    BufferlineOffsetTitleBright = { fg = palette.pink, bg = palette.mantle },

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
