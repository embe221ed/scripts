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
vim.o.numberwidth       = 1
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

function StatusColumn()
  local bufnr = vim.api.nvim_get_current_buf()
  local signs = vim.fn.sign_getplaced(bufnr, { group = '*' })
  local has_sign = false

  if signs and #signs > 0 and signs[1].signs then
    has_sign = #signs[1].signs > 0
  end

  if has_sign then return ""
  else return " " end
end

vim.o.statuscolumn      = "%{v:lua.StatusColumn()}%s%l%C "
