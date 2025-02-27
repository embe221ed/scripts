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
vim.o.clipboard         = "unnamedplus"
vim.o.expandtab         = true
vim.o.splitright        = true
vim.o.splitbelow        = true
vim.o.updatetime        = 500
vim.o.conceallevel      = 2

vim.o.list              = true

vim.opt.listchars:append "eol:↴"
vim.opt.fillchars:append "vert:▏"

vim.opt.termguicolors   = true

vim.g.one_allow_italics = true
vim.g.vimtex_view_method = "skim"
vim.g.indentLine_fileTypeExclude = {
  "lspinfo",
  "packer",
  "checkhealth",
  "dashboard",
  "help",
  "man",
  "diff",
  "git",
  "",
}

vim.lsp.set_log_level("off")
