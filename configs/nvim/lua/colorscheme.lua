local globals = require('globals')

local colorscheme = globals.colorscheme
local current_theme = globals.current_theme

if colorscheme == 'tokyonight' then
  ---@class tokyonight.Config
  require('tokyonight').setup({
    style = current_theme, -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
    light_style = "day", -- The theme is used when the background is set to light
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
elseif colorscheme == 'catppuccin' then
  -- Catppuccin theme
  local palette = globals.get_palette(colorscheme, current_theme)
  require('catppuccin').setup  {
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
      conditionals = { "italic" },
      loops = {},
      functions = {},
      keywords = { "italic" },
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
      -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    color_overrides = {
      latte = {
        text = "#6c6f85",
      },
      frappe = {
        lavender = "#b4b5ee",
      }
    },
    custom_highlights = {
      NoicePopup                  = { bg = palette.crust },
      NoiceCmdlinePopupBorder     = { fg = palette.surface1, style = { "bold" } },

      TabLineSel                  = { bg = palette.mauve },
      FloatBorder                 = { fg = palette.surface1, bg = palette.base, style = { "bold" } },

      StatusLine                  = { fg = palette.base, bg = palette.base },
      StatusLineNC                = { fg = palette.base, bg = palette.base },

      CursorLineNr                = { fg = palette.mauve, style = { "bold" } },

      OutlineCurrent              = { fg = palette.peach, bg = "", style = { "bold" } },

      TelescopeTitle              = { fg = palette.cyan },
      TelescopeBorder             = { fg = palette.surface1, style = { "bold" } },

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
      NvimTreeNormal              = { fg = palette.text, bg = palette.mantle },
      NvimTreeExecFile            = { fg = palette.red },
      NvimTreeOpenedHL            = { fg = palette.subtext0, style = { "italic" } },
      NvimTreeStatusLine          = { fg = palette.base, bg = palette.base },
      NvimTreeStatusLineNC        = { fg = palette.base, bg = palette.base },

      TreesitterContextBottom     = { sp = palette.surface1, style = { "underline" } },

      BufferlineOffsetTitleBase   = { fg = palette.overlay0, bg = palette.mantle },
      BufferlineOffsetTitleBright = { fg = palette.overlay0, bg = palette.mantle },

      ["@parameter.readonly"]     = { fg = palette.maroon, style = { "italic" } },
      ["@parameter.modification"] = { fg = palette.maroon, style = { "italic" } },

    }, -- Override highlight groups
    default_integrations = false,
    integrations = {
      cmp = true,
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
  }
end

vim.cmd.colorscheme(globals.colorscheme)
