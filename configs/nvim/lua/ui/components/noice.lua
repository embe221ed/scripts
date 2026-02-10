local format = {
  cmdline     = { pattern = "^:", icon = "", lang = "vim", title = "" },
  telescope   = { pattern = "^:%s*Tel?e?s?c?o?p?e?%s+", icon = " ", lang = "vim", title = "" },
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

local border = function()
  if vim.g.neovide or vim.g.border == "none" then return { style = "none", padding = { 1, 2 } } end
  -- if vim.g.border == "none" then
  --   return {
  --     style = { " ", "▄", " ", " ", " ", "▀", " ", " " },
  --     padding = { 0, 2 },
  --   }
  -- end
  return { style = vim.g.border }
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
    hover = {
      win_options = {
        winblend = vim.g.winblend,
      },
    },
    cmdline_popup = {
      position = { row = "30%", col = "50%", },
      size = { width = "25%", height = "auto", },
      border = border(),
      filter_options = {},
    },
  },
})

-- remove title in cmdline popup
local formats = require("noice.config").defaults().cmdline.format
for k, v in pairs(formats) do
  v.title = ""
  format[k] = v
end
