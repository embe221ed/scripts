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
      -- Check if current window is floating
      local win_config = api.nvim_win_get_config(0)
      local is_floating = win_config.relative ~= ""
      local is_special_buffer = vim.bo.buftype ~= ""

      -- Only enable spellcheck if not in a floating window
      if not is_floating and not is_special_buffer then
        api.nvim_set_option_value("spell",      true,    { scope = "local" })
        api.nvim_set_option_value("spelllang",  "en_us", { scope = "local" })
      end
    end,
  }
)

api.nvim_create_autocmd(
  "FileType",
  {
    desc      = "disable virtual_lines for filetypes",
    pattern   = { "lazy" },
    callback  = function()
      vim.diagnostic.config({
        virtual_lines = false,
      })
    end,
  }
)

api.nvim_create_autocmd(
  "FileType",
  {
    desc      = "set some options for move files",
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
      local active_tab = require('no-neck-pain.state').active_tab
      if active_tab ~= 1 then
        require('no-neck-pain').disable()
      end
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

vim.api.nvim_create_autocmd(
  'BufWinEnter',
  {
    desc      = "update the statuscolumn for specific filetypes to reduce its size",
    callback  = function()
      local ft = vim.bo.filetype
      local filetypes = {
        'NvimTree',
        'Outline',
      }
      for _, _ft in ipairs(filetypes) do
        if ft == _ft then
          vim.o.statuscolumn = '%s'
          vim.o.statusline = nil
          break
        end
      end
    end
  }
)

-- -- auto_close working implementation
-- vim.api.nvim_create_autocmd('BufEnter', {
--     command = "if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif",
--     nested = true,
-- })
