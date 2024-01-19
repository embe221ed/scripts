-- open NoNeckPain layout and run NoNeckPainResize with provided parameter
vim.api.nvim_create_user_command(
  "NNP",
  function(opts)
    local palette = require("catppuccin.palettes").get_palette("macchiato")
    assert(#opts.fargs > 0, "invalid params number: " .. #opts.fargs .. ", at least 1 argument required")
    -- fetch the NoNeckPain config
    local config = require("no-neck-pain").config
    -- set the width
    local ssize = opts.fargs[1]
    local size = assert(tonumber(ssize), "invalid input: " .. ssize .. " is not a number")
    config.width = size
    -- set fileName of buffers if provided
    if #opts.fargs == 2 then
      local name = opts.fargs[2]
      local buffers_config = config.buffers
      buffers_config.scratchPad.fileName = name
      for _, side in ipairs({ "left", "right" }) do
        buffers_config[side].scratchPad.fileName = name
      end
    end
    -- run NoNeckPain command
    vim.cmd("NoNeckPain")
  end,
  {
    nargs = "+",
    desc = "Open NoNeckPain layout with provided width [and scratchPad name] parameters",
    complete = function(_, cmd, _)
      local files_set = {}
      local i = string.find(cmd, "NNP")
      if i == nil then return {} end
      if string.match(cmd, "NNP%s+%d+%s+") == nil then return {} end
      for file in io.popen('ls ${HOME}/Desktop/nnp-notes'):lines() do
        file = string.match(file, "(.*)-left.nnp") or string.match(file, "(.*)-right.nnp")
        files_set[file] = 1
      end
      local files = {}
      for filename, _ in pairs(files_set) do
        table.insert(files, filename)
      end
      return files
    end
  }
)

vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local _wins = {}
    -- local floating_wins = {}
    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if bufname:match("NvimTree_") ~= nil then
        table.insert(_wins, w)
      end
      if bufname:match("OUTLINE_") ~= nil then
        table.insert(_wins, w)
      end
      --[[ if vim.api.nvim_win_get_config(w).relative ~= '' then
        table.insert(floating_wins, w)
      end ]]
    end
    -- if 1 == #wins - #floating_wins - #_wins then
    if 1 == #wins - #_wins then
      -- Should quit, so we close all invalid windows.
      for _, w in ipairs(_wins) do
        vim.api.nvim_win_close(w, true)
      end
    end
  end
})
