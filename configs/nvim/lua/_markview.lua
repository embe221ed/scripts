-- custom configuration for the markview.nvim plugin

require('markview').setup({
  preview = {
    filetypes = { "markdown", "quarto", "rmd", "norg", "Avante" },
    ignore_buftypes = {},
  },
  experimental = {
    prefer_nvim = true,
    file_open_command = "edit",
  },
})
