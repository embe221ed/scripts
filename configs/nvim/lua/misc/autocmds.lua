local api = vim.api
local group = api.nvim_create_augroup("user_autocmds", { clear = true })

api.nvim_create_autocmd(
  "FileType",
  {
    group     = group,
    desc      = "enable spellcheck for markdown and norg files, set indentation to 4 spaces",
    pattern   = { "markdown", "txt", "norg" },
    callback  = function()
      vim.bo.shiftwidth  = 4
      vim.bo.tabstop     = 4
      -- Check if current window is floating
      local win_config = api.nvim_win_get_config(0)
      local is_floating = win_config.relative ~= ""
      local is_special_buffer = vim.bo.buftype ~= ""

      -- Only enable spellcheck if not in a floating window
      if not is_floating and not is_special_buffer then
        vim.wo.spell = true
        vim.bo.spelllang = "en_us"
      end
    end,
  }
)

api.nvim_create_autocmd(
  "FileType",
  {
    group     = group,
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
    group     = group,
    desc      = "set some options for move files",
    pattern   = { "move" },
    callback  = function()
      vim.bo.commentstring = "// %s"
    end,
  }
)

api.nvim_create_autocmd(
  "TermOpen",
  {
    group     = group,
    desc      = "do not show line numbers in terminal buffer",
    pattern   = { "*" },
    callback  = function()
      vim.wo.number = false
      vim.wo.relativenumber = false
    end,
  }
)

api.nvim_create_autocmd(
  "User",
  {
    group     = group,
    desc      = "ensure that special buffers are closed before saving the session",
    pattern   = "PersistenceSavePre",
    callback  = function()
      require('nvim-tree.api').tree.close()
      require('outline').close()
    end,
  }
)

api.nvim_create_autocmd(
  { "FileType", "BufWinEnter" },
  {
    group = group,
    pattern = { "Outline" },
    callback = function(args)
      vim.schedule(function()
        -- Find all windows displaying this specific buffer
        local wins = vim.fn.win_findbuf(args.buf)
        for _, win in ipairs(wins) do
          -- Apply only to the sidebar windows, not the current active window
          api.nvim_set_option_value("statuscolumn", "",  { scope = "local", win = win })
          api.nvim_set_option_value("statusline",   " ", { scope = "local", win = win })
        end
      end)
    end,
  }
)
