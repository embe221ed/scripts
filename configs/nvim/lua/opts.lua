--------------------------------------------------------------------------------
-- standard options
--------------------------------------------------------------------------------
vim.opt.shiftwidth        = 2
vim.opt.tabstop           = 2
vim.opt.smartcase         = true
vim.opt.ignorecase        = true
vim.opt.cursorline        = true
vim.opt.number            = true
vim.opt.relativenumber    = true
vim.opt.numberwidth       = 1
vim.opt.statuscolumn      = "%C %s%l "
vim.opt.foldcolumn        = "auto:9"
vim.opt.clipboard         = "unnamedplus"
vim.opt.expandtab         = true
vim.opt.splitright        = true
vim.opt.splitbelow        = true
vim.opt.updatetime        = 500
vim.opt.conceallevel      = 2
vim.opt.smoothscroll      = true

vim.opt.list              = true

vim.opt.listchars:append "eol:↴"
vim.opt.fillchars:append "vert:▏,foldopen:┌,foldclose:›,fold: "

vim.opt.termguicolors   = true

vim.lsp.set_log_level("off")

vim.opt.foldexpr = "v:lua.require('utils').foldexpr()"
vim.opt.foldmethod = "manual"
vim.opt.foldtext = ""
