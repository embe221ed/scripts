require("nord").setup({
  -- your configuration comes here
  -- or leave it empty to use the default settings
  transparent = false, -- Enable this to disable setting the background color
  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
  diff = { mode = "bg" }, -- enables/disables colorful backgrounds when used in diff mode. values : [bg|fg]
  borders = true, -- Enable the border between verticaly split windows visible
  errors = { mode = "bg" }, -- Display mode for errors and diagnostics
                            -- values : [bg|fg|none]
  search = { theme = "vim" }, -- theme for highlighting search results
                              -- values : [vim|vscode]
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = true },
    keywords = {},
    functions = {},
    variables = {},

    -- To customize lualine/bufferline
    bufferline = {
      current = {},
      modified = {},
    },
  },

  -- colorblind mode
  -- see https://github.com/EdenEast/nightfox.nvim#colorblind
  -- simulation mode has not been implemented yet.
  colorblind = {
    enable = false,
    preserve_background = false,
    severity = {
      protan = 0.0,
      deutan = 0.0,
      tritan = 0.0,
    },
  },

  -- Override the default colors
  ---@param colors Nord.Palette
  on_colors = function(colors) end,

  --- You can override specific highlights to use other groups or a hex color
  --- function will be called with all highlights and the colorScheme table
  ---@param colors Nord.Palette
  on_highlights = function(highlights, _colors)
    require('ui.colors').initialize_colors(_colors)
    local colors = vim.g.colors
    -- highlights.WinSeparator                = { fg = colors.surface0 }
    -- highlights.TabLineSel                  = { bg = colors.pink }
    -- highlights.FloatBorder                 = { fg = colors.surface1, bg = colors.base, style = { "bold" } }
    highlights.NormalFloat                  = { bg = colors.bg }
    -- highlights.PmenuSel                    = { bg = colors.surface1, style = {} }

    -- highlights.BlinkCmpLabelDescription    = { fg = colors.overlay0, style = { "italic" } }

    highlights.NoicePopup                  = { bg = _colors.polar_night.brighter }
    -- highlights.NoiceCmdlinePopupBorder     = { fg = colors.surface1, style = { "bold" } }

    highlights.StatusLine                  = { fg = colors.bg, bg = colors.bg }
    highlights.StatusLineNC                = { fg = colors.bg, bg = colors.bg }

    -- highlights.CursorLineNr                = { fg = colors.pink, style = { "bold" } }

    highlights.OutlineCurrent              = { bold = true }

    -- highlights.TelescopeTitle              = { fg = colors.cyan }
    -- highlights.TelescopeBorder             = { fg = colors.surface1, style = { "bold" } }

    highlights.AvanteInlineHint            = { italic = true }

    -- highlights.NvimTreeFolderName          = { fg = colors.peach }
    -- highlights.NvimTreeFolderIcon          = { fg = colors.peach }
    -- highlights.NvimTreeOpenedFolderName    = { fg = colors.peach }
    -- highlights.NvimTreeEmptyFolderName     = { fg = colors.peach }
    -- highlights.NvimTreeIndentMarker        = { fg = colors.overlay0 }
    highlights.NvimTreeWinSeparator        = { fg = colors.bg, bg = colors.bg, }
    -- highlights.NvimTreeRootFolder          = { fg = colors.peach, style = { "bold" } }
    -- highlights.NvimTreeSymlink             = { fg = colors.pink }
    -- highlights.NvimTreeGitDirty            = { fg = colors.yellow }
    -- highlights.NvimTreeGitNew              = { fg = colors.blue }
    -- highlights.NvimTreeGitDeleted          = { fg = colors.red }
    -- highlights.NvimTreeSpecialFile         = { fg = colors.flamingo }
    -- highlights.NvimTreeImageFile           = { fg = colors.text }
    -- highlights.NvimTreeOpenedFile          = { fg = colors.pink }
    highlights.NvimTreeNormal              = { bg = colors.alt_bg }
    highlights.NvimTreeNormalNC            = { bg = colors.alt_bg }
    highlights.NvimTreeCursorLine          = { bg = _colors.polar_night.brighter }
    -- highlights.NvimTreeExecFile            = { fg = colors.red }
    -- highlights.NvimTreeOpenedHL            = { fg = colors.surface2 }
    highlights.NvimTreeStatusLine          = { fg = colors.bg, bg = colors.bg }
    highlights.NvimTreeStatusLineNC        = { fg = colors.bg, bg = colors.bg }
    --
    highlights.TreesitterContextBottom     = { sp = colors.alt_fg, underline = true }
    --
    -- highlights["@parameter.readonly"]     = { fg = colors.maroon, style = { "italic" } }
    -- highlights["@parameter.modification"] = { fg = colors.maroon, style = { "italic" } }
  end,
})
