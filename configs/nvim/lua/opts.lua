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
vim.o.conceallevel    = 2

vim.o.list            = true

vim.opt.listchars:append "eol:↴"
vim.opt.fillchars:append "vert:▏"

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

api.nvim_create_user_command('Markserv', '!tmux new -d "markserv . --silent"', {})

api.nvim_create_autocmd(
  "FileType",
  {
    desc      = "enable spellcheck for markdown and norg files, set indentation to 4 spaces",
    pattern   = { "markdown", "txt", "norg" },
    callback  = function()
      vim.o.shiftwidth  = 4
      vim.o.tabstop     = 4
      api.nvim_set_option_value("spell",      true,    { scope = "local" })
      api.nvim_set_option_value("spelllang",  "en_us", { scope = "local" })
    end,
  }
)

api.nvim_create_autocmd(
  "FileType",
  {
    desc      = "set the commentstring for move files",
    pattern   = { "move" },
    callback  = function()
      api.nvim_set_option_value("commentstring",  "// %s", { scope = "local" })
    end,
  }
)

api.nvim_create_autocmd(
  "TermOpen",
  {
    desc      = "do not show line numbers in terminal buffer",
    pattern   = { "*" },
    callback  = function()
      api.nvim_set_option_value("number",          false,  { scope = "local" })
      api.nvim_set_option_value("relativenumber",  false,  { scope = "local" })
    end,
  }
)

api.nvim_create_autocmd(
  "User",
  {
    desc      = "ensure that the NoNeckPain buffers are closed before saving the session",
    pattern   = "PersistenceSavePre",
    callback  = function()
      require('no-neck-pain').disable()
      require('nvim-tree.api').tree.close()
      require('outline').close()
      local ft_to_close = "norg"
      for _, buf in ipairs(api.nvim_list_bufs()) do
        if api.nvim_buf_is_loaded(buf) and api.nvim_get_option_value("filetype", { buf = buf }) == ft_to_close then
          api.nvim_buf_delete(buf, {})
        end
      end
    end,
  }
)

vim.lsp.set_log_level("off")
