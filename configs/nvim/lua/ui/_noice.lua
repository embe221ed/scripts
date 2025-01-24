require("noice").setup {
  cmdline = {
    format = {
      cmdline =   { pattern = "^:", icon = "_", lang = "vim" },
      telescope = { pattern = "^:%s*Tel?e?s?c?o?p?e?%s+", icon = " ", lang = "vim" },
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
  views = {
    cmdline_popup = {
      position = { row = "20%", col = "50%", },
      size = { width = "auto", height = "auto", },
      border = { style = "rounded" },
      filter_options = {},
      win_options = {
        winhighlight = {
          FloatBorder = "FloatBorder",
        },
      },
    },
  },
}
