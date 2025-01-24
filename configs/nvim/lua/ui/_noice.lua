local format = {
  cmdline     = { pattern = "^:", icon = "_", lang = "vim" },
  telescope   = { pattern = "^:%s*Tel?e?s?c?o?p?e?%s+", icon = "", lang = "vim" },
}
if vim.g.symbol_font then
  format = {
    cmdline     = { pattern = "^:", icon = " ", lang = "vim" },
    telescope   = { pattern = "^:%s*Tel?e?s?c?o?p?e?%s+", icon = " ", lang = "vim" },
    lua         = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = " ", lang = "lua" },
    help        = { pattern = "^:%s*he?l?p?%s+", icon = "" },
    search_down = { kind = "search", pattern = "^/", icon = " 󰶹 ", lang = "regex" },
    search_up   = { kind = "search", pattern = "^%?", icon = " 󰶼 ", lang = "regex" },
  }
end

require("noice").setup {
  cmdline = {
    format = format,
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
