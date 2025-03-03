--------------------------------------------------------------------------------
-- standard options
--------------------------------------------------------------------------------
vim.o.shiftwidth        = 2
vim.o.tabstop           = 2
vim.o.smartcase         = true
vim.o.ignorecase        = true
vim.o.cursorline        = true
vim.o.number            = true
vim.o.relativenumber    = true
vim.o.statuscolumn      = " %s%l%C "
vim.o.foldcolumn        = "auto:9"
vim.o.clipboard         = "unnamedplus"
vim.o.expandtab         = true
vim.o.splitright        = true
vim.o.splitbelow        = true
vim.o.updatetime        = 500
vim.o.conceallevel      = 2

vim.o.list              = true

vim.opt.listchars:append "eol:↴"
vim.opt.fillchars:append "vert:▏,foldopen:┌"

vim.opt.termguicolors   = true

vim.lsp.set_log_level("off")
