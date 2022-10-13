vim.o.shiftwidth      = 2
vim.o.tabstop         = 2
vim.o.ignorecase      = true
vim.o.cursorline      = true
vim.o.number          = true
vim.o.relativenumber  = true
vim.o.clipboard       = "unnamedplus"
vim.o.expandtab       = true


local api = vim.api

api.nvim_create_autocmd(
  "FileType",
  {
    pattern = { "markdown", "txt" },
    callback = function()
      vim.o.shiftwidth 	= 4
      vim.o.tabstop 	= 4
    end,
  }
)
