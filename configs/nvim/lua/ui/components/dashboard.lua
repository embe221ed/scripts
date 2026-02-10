local generate_desc = require('utils').generate_desc

return {
  "glepnir/dashboard-nvim",                                       -- dashboard
  config = function()
    require('dashboard').setup {
      theme = 'doom',
      config = {
        header = {
          '', '', '', '', '', '',
          ' ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗  █████╗ ██████╗ ██████╗  ',
          ' ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██╔══██╗ ',
          ' ██║  ██║███████║███████╗███████║██████╔╝██║   ██║███████║██████╔╝██║  ██║ ',
          ' ██║  ██║██╔══██║╚════██║██╔══██║██╔══██╗██║   ██║██╔══██║██╔══██╗██║  ██║ ',
          ' ██████╔╝██║  ██║███████║██║  ██║██████╔╝╚██████╔╝██║  ██║██║  ██║██████╔╝ ',
          ' ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝  ',
          '', '',
        },
        center = {
          {
            desc = generate_desc('update plugins'),
            desc_hl = 'Identifier',
            action = 'Lazy sync',
            key = 'u',
            key_hl = '@markup.strong',
            key_format = ' %s',
          },
          {
            icon_hl = 'Identifier',
            desc = generate_desc('find file'),
            desc_hl = 'Identifier',
            -- action = 'Telescope find_files',
            action = 'lua Snacks.picker.files()',
            key = 'f',
            key_hl = '@markup.strong',
            key_format = ' %s',
          },
          {
            desc = generate_desc('open file explorer'),
            desc_hl = 'Identifier',
            -- action = 'Telescope file_browser',
            action = 'lua Snacks.explorer.open()',
            key = 'e',
            key_hl = '@markup.strong',
            key_format = ' %s',
          },
          {
            desc = generate_desc('recently opened'),
            desc_hl = 'Identifier',
            -- action = 'Telescope oldfiles',
            action = 'lua Snacks.picker.recent()',
            key = 'h',
            key_hl = '@markup.strong',
            key_format = ' %s',
          },
          {
            desc = generate_desc('restore session'),
            desc_hl = 'Identifier',
            action = 'lua require(\'persistence\').load()',
            key = 'r',
            key_hl = '@markup.strong',
            key_format = ' %s',
          },
          {
            desc = generate_desc('sessions'),
            desc_hl = 'Identifier',
            action = 'lua require(\'persistence\').select()',
            key = 's',
            key_hl = '@markup.strong',
            key_format = ' %s',
          },
          {
            desc = generate_desc('find word'),
            desc_hl = 'Identifier',
            -- action = 'Telescope live_grep',
            action = 'lua Snacks.picker.grep()',
            key = 'w',
            key_hl = '@markup.strong',
            key_format = ' %s',
          },
          {
            desc = generate_desc('LSP debug level'),
            desc_hl = 'Identifier',
            action = 'lua vim.lsp.log.set_level("debug")',
            key = 'd',
            key_hl = '@markup.strong',
            key_format = ' %s',
          },
          {
            desc = generate_desc('quit'),
            desc_hl = 'Identifier',
            action = 'quitall',
            key = 'q',
            key_hl = '@markup.strong',
            key_format = ' %s',
          },
        },
      },
    }
  end,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
