local lualine = require('lualine')

-- Color table for highlights
-- stylua: ignore
local colors = vim.g.colors

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

local disabled_filetypes = {}
if vim.g.statusline.laststatus < 3 then
  disabled_filetypes = {
    'NvimTree',
    'qf',
    'loc',
    'Outline',
    'norg',
    'dashboard',
    'help',
    'dapui_scopes',
    'dapui_breakpoints',
    'dapui_stacks',
    'dapui_watches',
    'dapui_watches',
    'dap-repl',
    'dapui_console',
  }
end

-- Config
local config = {
  options = {
    -- component_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    theme = {
      -- We are going to use lualine_c an lualine_x as left and
      -- right section. Both are highlighted by c theme .  So we
      -- are just setting default looks o statusline
      normal = { c = { fg = colors.fg, bg = colors.dark_bg } },
      inactive = { c = { fg = colors.fg, bg = colors.dark_bg } },
    },
    disabled_filetypes = disabled_filetypes,
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
    table.insert(config.inactive_sections.lualine_x, component)
  end
end

ins_left(
  {
    function()
      return ' '
    end,
    color = { fg = colors.fg, gui = 'bold' }, -- Sets highlighting of component
    padding = { left = 1, right = 1 }, -- We don't need space before this
  },
  true
)

ins_left {
  -- mode component
  function()
    return string.format("-- %s --", require("lualine.utils.mode").get_mode())
  end,
}

ins_left(
  {
    'filename',
    cond = conditions.buffer_not_empty,
    color = { fg = colors.accent, gui = 'bold' },
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
      ---@diagnostic disable-next-line: undefined-field
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

ins_left { 'diagnostics' }

-- Add components to right sections
ins_right {
  'diff',
  symbols = { added = ' ', modified = '󱗝 ', removed = ' ' },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  cond = conditions.hide_in_width,
}

ins_right {
  'selectioncount',
  color = { fg = colors.fg, gui = 'bold' },
}

ins_right { 'location' }

ins_right {
  function()
    local cur = vim.fn.line('.')
    local total = vim.fn.line('$')
    local p = math.floor(cur / total * 100)
    local icon = ''
    if p == 100 then icon = '  '
    elseif p >= 87 then icon = '▁▁▁'
    elseif p >= 75 then icon = '▂▂▂'
    elseif p >= 62 then icon = '▃▃▃'
    elseif p >= 50 then icon = '▄▄▄'
    elseif p >= 37 then icon = '▅▅▅'
    elseif p >= 25 then icon = '▆▆▆'
    elseif p >= 10 then icon = '▇▇▇'
    else icon = '███'
    end
    return string.format('%s %%#lualine_c_normal#%2d%%%%', icon, p)
  end,
  color = { fg = colors.bg, },
}

-- Now don't forget to initialize lualine
---@diagnostic disable: undefined-field
if vim.g.colorscheme.vanilla then lualine.setup({})
else lualine.setup(config)
end
---@diagnostic enable: undefined-field
