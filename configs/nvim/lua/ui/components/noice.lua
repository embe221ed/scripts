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

require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      -- override the default lsp markdown formatter with Noice
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      -- override the lsp markdown formatter with Noice
      ["vim.lsp.util.stylize_markdown"] = true,
      -- override cmp documentation with Noice (needs the other options to work)
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  cmdline = {
    format = format,
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = vim.g.lsp.doc.border, -- add a border to hover docs and signature help
  },
  views = {
    cmdline_popup = {
      position = { row = "20%", col = "50%", },
      size = { width = "auto", height = "auto", },
      border = { style = vim.g.border },
      filter_options = {},
      win_options = {
        winhighlight = {
          FloatBorder = "FloatBorder",
        },
      },
    },
  },
})
