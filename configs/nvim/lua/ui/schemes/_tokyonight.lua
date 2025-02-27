local current_theme = vim.g.colorscheme.theme

---@diagnostic disable: inject-field, undefined-field, undefined-doc-name
---@class tokyonight.Config
require('tokyonight').setup({
  style = current_theme, -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
  light_style = current_theme, -- The theme is used when the background is set to light
  transparent = false, -- Enable this to disable setting the background color
  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = true },
    conditionals = { italic = true },
    keywords = {},
    functions = {},
    variables = {},
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = "dark", -- style for sidebars, see below
    floats = "dark", -- style for floating windows
  },
  day_brightness = 0.5, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
  dim_inactive = false, -- dims inactive windows
  lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

  --- You can override specific color groups to use other groups or a hex color
  --- function will be called with a ColorScheme table
  ---@param colors ColorScheme
  on_colors = function(colors)
    colors.border_highlight = "#29a4bd"
  end,

  --- You can override specific highlights to use other groups or a hex color
  --- function will be called with a Highlights and ColorScheme table
  ---@param highlights tokyonight.Highlights
  ---@param colors ColorScheme
  on_highlights = function(highlights, colors)
    highlights.TabLineSel                   = { bg = colors.magenta2 }
    highlights.FloatBorder                  = { fg = colors.border_highlight, bg = colors.bg, bold = true }
    highlights.FloatTitle                   = { fg = colors.border_highlight, bg = colors.bg }
    highlights.StatusLine                   = { fg = colors.bg, bg = colors.bg }
    highlights.StatusLineNC                 = { fg = colors.bg, bg = colors.bg }

    highlights.NoicePopup                   = { bg = colors.bg_dark }

    highlights.OutlineCurrent               = { fg = colors.green, bg = "", bold = true }

    highlights.TelescopeTitle               = { fg = colors.cyan }
    highlights.TelescopeNormal              = { bg = colors.bg }
    highlights.TelescopeBorder              = { fg = colors.border_highlight, bg = colors.bg }
    highlights.TelescopePromptTitle         = { fg = colors.orange, bg = colors.bg }
    highlights.TelescopePromptBorder        = { fg = colors.orange, bg = colors.bg }

    highlights.TreesitterContext            = { bg = colors.bg }

    highlights.NvimTreeExecFile             = { fg = colors.red }
    highlights.NvimTreeOpenedHL             = { fg = colors.comment, italic = true }
    highlights.NvimTreeRootFolder           = { fg = colors.magenta2, bold = true }
    highlights.NvimTreeStatusLine           = { fg = colors.bg, bg = colors.bg }
    highlights.NvimTreeStatusLineNC         = { fg = colors.bg, bg = colors.bg }
    highlights.NvimTreeWinSeparator         = { fg = colors.bg, bg = colors.bg }

    highlights["@namespace"]                = highlights["@module"]

    if current_theme == "day" then
      highlights.Search                     = { fg = colors.bg_dark, bg = colors.blue2 }
    end
  end,

  cache = true, -- When set to true, the theme will be cached for better performance

  ---@type table<string, boolean|{enabled:boolean}>
  plugins = {
    -- enable all plugins when not using lazy.nvim
    -- set to false to manually enable/disable plugins
    all = package.loaded.lazy == nil,
    -- uses your plugin manager to automatically enable needed plugins
    -- currently only lazy.nvim is supported
    auto = true,
    -- add any plugins here that you want to enable
    -- for all possible plugins, see:
    --   * https://github.com/folke/tokyonight.nvim/tree/main/lua/tokyonight/groups
    -- telescope = true,
    bufferline = false,
  },
})
---@diagnostic enable: inject-field, undefined-field, undefined-doc-name
