local colors = vim.g.colors

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

local theme = {
  normal = {
    a = { fg = colors.bg, bg = colors.accent, gui = "bold" },
    b = { fg = colors.fg, bg = colors.comment, gui = "bold" },
    c = { fg = colors.dark_bg, bg = colors.bg, gui = "bold" },
    z = { fg = colors.fg, bg = colors.light_bg, gui = "bold" },
  },
  insert = { a = { fg = colors.bg, bg = colors.green, gui = "bold" } },
  command = { a = { fg = colors.bg, bg = colors.orange, gui = "bold" } },
  visual = { a = { fg = colors.bg, bg = colors.sky, gui = "bold" } },
  replace = { a = { fg = colors.bg, bg = colors.green, gui = "bold" } },
}

local empty = require('lualine.component'):extend()
function empty:draw(default_highlight)
  self.status = ''
  self.applied_separator = ''
  self:apply_highlights(default_highlight)
  self:apply_section_separators()
  return self.status
end

-- Put proper separators and gaps between components in sections
local function process_sections(sections)
  for name, section in pairs(sections) do
    local left = name:sub(9, 10) < 'x'
    for pos = 1, name ~= 'lualine_z' and #section or #section - 1 do
      table.insert(section, pos * 2, { empty, color = { fg = colors.bg, bg = colors.bg } })
    end
    for id, comp in ipairs(section) do
      if type(comp) ~= 'table' then
        comp = { comp }
        section[id] = comp
      end
      comp.separator = left and { right = '' } or { left = '' }
    end
  end
  return sections
end

local function search_result()
  if vim.v.hlsearch == 0 then
    return ''
  end
  local last_search = vim.fn.getreg('/')
  if not last_search or last_search == '' then
    return ''
  end
  local searchcount = vim.fn.searchcount { maxcount = 9999 }
  return last_search .. ' (' .. searchcount.current .. '/' .. searchcount.total .. ')'
end

local function modified()
  if vim.bo.modified then
    return '+'
  elseif vim.bo.modifiable == false or vim.bo.readonly == true then
    return '-'
  end
  return ''
end

require('lualine').setup {
  options = {
    theme = theme,
    component_separators = '',
    section_separators = { left = '', right = '' },
    disabled_filetypes = disabled_filetypes,
  },
  sections = process_sections {
    lualine_a = { 'mode' },
    lualine_b = {
      'branch',
      { 'filename' },
      { modified, color = { bg = colors.red } },
      {
        '%w',
        cond = function()
          return vim.wo.previewwindow
        end,
      },
      {
        '%r',
        cond = function()
          return vim.bo.readonly
        end,
      },
      {
        '%q',
        cond = function()
          return vim.bo.buftype == 'quickfix'
        end,
      },
      {
        function()
          -- local msg = 'n/a'
          local msg = ''
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
        icon = ' ',
        color = { fg = colors.fg, gui = 'bold' },
      },
      'diagnostics',
    },
    lualine_c = {},
    lualine_x = {},
    lualine_y = { 'selectioncount', search_result, 'diff', 'filetype' },
    lualine_z = { '%l:%c', '%p%% / %L' },
  },
  inactive_sections = {
    lualine_c = { '%f %y %m' },
    lualine_x = {},
  },
}
