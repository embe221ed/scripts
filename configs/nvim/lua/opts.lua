vim.o.shiftwidth      = 2
vim.o.tabstop         = 2
vim.o.smartcase       = true
vim.o.ignorecase      = true
vim.o.cursorline      = true
vim.o.number          = true
vim.o.relativenumber  = true
vim.o.clipboard       = "unnamedplus"
vim.o.expandtab       = true
vim.o.splitright      = true
vim.o.splitbelow      = true

vim.g.one_allow_italics = true
vim.g.vimtex_view_method = "skim"
vim.g.indentLine_fileTypeExclude = {
  "lspinfo",
  "packer",
  "checkhealth",
  "help",
  "man",
  "diff",
  "git",
  "",
}

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

api.nvim_create_user_command('Markserv', '!tmux new -d "markserv . --silent"', {})

-- vim.lsp.set_log_level("debug")

