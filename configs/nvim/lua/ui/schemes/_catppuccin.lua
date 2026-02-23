-- Catppuccin theme
local utils = require('utils')
local colorscheme = vim.g.colorscheme.name
local current_theme = vim.g.colorscheme.theme

local color_overrides = {
  latte = {
    -- text = "#6c6f85",
    peach = "#f28d5e",
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
  lsp_styles = {
    inlay_hints = {
      background = false,
    }
  },
  color_overrides = color_overrides,
  custom_highlights = {
    WinSeparator                = { fg = colors.light_bg },
    TabLineSel                  = { bg = colors.accent },

    FloatBorder                 = utils.ternary(vim.g.border == "none", { fg = colors.alt_bg, bg = colors.alt_bg }, { fg = colors.light_bg, bg = colors.none }),
    FloatTitle                  = utils.ternary(vim.g.border == "none", { fg = colors.alt_fg, bg = colors.alt_bg }, { fg = colors.light_bg, bg = colors.none }),
    NormalFloat                 = utils.ternary(vim.g.border == "none", {}, { bg = colors.none }),

    PmenuSel                    = { bg = colors.alt_fg, style = {} },
    -- PmenuSbar                   = { bg = utils.darken(colors.light_bg, 0.8, palette.crust), },

    BlinkCmpLabelDescription    = { fg = colors.comment, style = { "italic" } },

    NoicePopup                  = { bg = colors.dark_bg },
    NoiceCmdlinePopupBorder     = utils.ternary(vim.g.border == "none", { fg = colors.light_bg, bg = colors.bg }, { fg = colors.light_bg }),
    NoiceCmdlinePopup           = utils.ternary(vim.g.border == "none", { bg = colors.light_bg }, {}),

    StatusLine                  = { fg = colors.bg, bg = colors.bg },
    StatusLineNC                = { fg = colors.bg, bg = colors.bg },

    CursorLineNr                = { fg = colors.accent, style = { "bold" } },

    OutlineCurrent              = { fg = colors.orange, bg = "", style = { "bold" } },

    -- Telescope
    TelescopeTitle              = { fg = palette.cyan },
    TelescopeNormal             = { fg = colors.fg, bg = colors.dark_bg },
    TelescopeBorder             = { fg = colors.dark_bg, bg = colors.dark_bg },
    TelescopePromptNormal       = { fg = colors.fg, bg = colors.light_bg },
    TelescopePromptBorder       = { fg = colors.light_bg, bg = colors.light_bg },
    TelescopePromptTitle        = { fg = colors.light_bg, bg = colors.red },
    TelescopePromptCounter      = { fg = colors.gray, bg = colors.surface0 },
    TelescopeResultsTitle       = { fg = colors.alt_fg, bg = colors.purple },
    TelescopeResultsNormal      = { fg = colors.fg, bg = colors.dark_bg },
    TelescopeResultsBorder      = { fg = colors.dark_bg, bg = colors.dark_bg },
    TelescopePreviewTitle       = { fg = colors.light_bg, bg = colors.green },
    TelescopeMatching           = { fg = colors.orange, style = { "bold" } },
    TelescopeDirectoryCustom    = { fg = colors.comment },

    -- TODO: not working
    AvanteInlineHint            = { fg = palette.overlay2, style = { "italic" } },

    NvimTreeFolderName          = { fg = colors.orange },
    NvimTreeFolderIcon          = { fg = colors.orange },
    NvimTreeOpenedFolderName    = { fg = colors.orange },
    NvimTreeEmptyFolderName     = { fg = colors.orange },
    NvimTreeIndentMarker        = { fg = colors.comment },
    NvimTreeWinSeparator        = { fg = colors.bg, bg = colors.bg, },
    NvimTreeRootFolder          = { fg = colors.orange, style = { "bold" } },
    NvimTreeSymlink             = { fg = colors.pink },
    NvimTreeGitDirty            = { fg = colors.yellow },
    NvimTreeGitNew              = { fg = colors.blue },
    NvimTreeGitDeleted          = { fg = colors.red },
    NvimTreeSpecialFile         = { fg = palette.flamingo },
    NvimTreeImageFile           = { fg = colors.fg },
    NvimTreeNormal              = { bg = colors.alt_bg },
    NvimTreeNormalNC            = { bg = colors.alt_bg },
    NvimTreeExecFile            = { fg = colors.red },
    -- NvimTreeStatusLine          = { fg = colors.alt_bg, bg = colors.alt_bg },
    -- NvimTreeStatusLineNC        = { fg = colors.alt_bg, bg = colors.alt_bg },

    TreesitterContext           = { bg = colors.bg },
    TreesitterContextBottom     = { sp = vim.g.neovide and colors.bg or colors.light_bg, style = { "underline" } },

    ["@parameter.readonly"]     = { fg = palette.maroon, style = { "italic" } },
    ["@parameter.modification"] = { fg = palette.maroon, style = { "italic" } },

    DapBreakpoint               = { fg = colors.red },
    DapStopped                  = { fg = colors.green },

    NotifyERRORTitle            = { fg = colors.red, style = {} },
    NotifyWARNTitle             = { fg = colors.yellow, style = {} },
    NotifyINFOTitle             = { fg = colors.blue, style = {} },
    NotifyDEBUGTitle            = { fg = colors.orange, style = {} },
    NotifyTRACETitle            = { fg = palette.rosewater, style = {} },

  }, -- Override highlight groups
  default_integrations = false,
  integrations = {
    cmp = true,
    blink_cmp = true,
    gitsigns = true,
    nvimtree = false,
    flash = true,
    lsp_trouble = true,
    markview = true,
    notify = true,
    mini = {
      enabled = true,
      indentscope_color = "",
    },
    snacks = true,
    treesitter = true,
    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  },
})
