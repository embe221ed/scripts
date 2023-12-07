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
vim.o.updatetime      = 500

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

api.nvim_create_autocmd(
  "FileType",
  {
    pattern = { "move" },
    callback = function()
      vim.api.nvim_buf_set_option(0, "commentstring", "// %s")
    end,
  }
)

-- vim.lsp.set_log_level("off")
vim.lsp.set_log_level("debug")
