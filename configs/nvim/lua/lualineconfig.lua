-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine = require('lualine')

local globals = require('globals')
local current_theme = globals.current_theme
local palette = globals.get_palette(globals.colorscheme, current_theme)

-- Color table for highlights
-- stylua: ignore
local colors = {
  -- bg        = palette.base,
  bg        = palette.bg,
  fg        = '#bbc2cf',
  yellow    = palette.yellow,
  cyan      = '#008080',
  darkblue  = '#081633',
  green     = palette.green,
  orange    = palette.orange,
  violet    = '#a9a1e1',
  magenta   = '#c678dd',
  blue      = palette.blue,
  red       = palette.red,
  -- mauve     = palette.mauve,
  mauve     = palette.magenta,
  -- pink      = palette.pink,
  pink      = palette.magenta2,
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = '',
    section_separators = '',
    theme = {
      -- We are going to use lualine_c an lualine_x as left and
      -- right section. Both are highlighted by c theme .  So we
      -- are just setting default looks o statusline
      normal = { c = { fg = colors.fg, bg = colors.bg } },
      inactive = { c = { fg = colors.fg, bg = colors.bg } },
    },
    disabled_filetypes = {
      'NvimTree', 'qf', 'loc', 'Outline', 'norg', 'dashboard', 'help',
    },
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component, inactive)
  table.insert(config.sections.lualine_c, component)
  if inactive then
    table.insert(config.inactive_sections.lualine_c, component)
  end
end

-- Inserts a component in lualine_x at right section
local function ins_right(component, inactive)
  table.insert(config.sections.lualine_x, component)
  if inactive then
    table.insert(config.inactive_sections.lualine_c, component)
  end
end

ins_left(
  {
    function()
      return ''
    end,
    color = { fg = colors.fg }, -- Sets highlighting of component
    padding = { left = 1, right = 1 }, -- We don't need space before this
  },
  true
)

ins_left {
  -- mode component
  function()
    return " " .. require("lualine.utils.mode").get_mode()
  end,
  fmt = string.lower,
  padding = { right = 1 },
}

ins_left(
  {
    'filename',
    cond = conditions.buffer_not_empty,
    color = { fg = colors.mauve, gui = 'bold' },
  },
  true
)

ins_left {
  -- Lsp server name .
  function()
    local msg = 'n/a'
    local buf_ft = vim.api.nvim_get_option_value('filetype', { scope = "local" })
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then
      return msg
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return client.name
      end
    end
    return msg
  end,
  icon = ' LSP:',
  color = { fg = colors.fg, gui = 'bold' },
}

-- Add components to right sections
ins_right {
  'selectioncount',
  color = { fg = colors.fg, gui = 'bold' },
}

ins_right { 'location' }

ins_right {
  'diff',
  symbols = { added = ' ', modified = '󱗜 ', removed = ' ' },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  cond = conditions.hide_in_width,
}

-- Now don't forget to initialize lualine
lualine.setup(config)
