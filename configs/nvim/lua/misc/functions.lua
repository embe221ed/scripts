local api = vim.api

-- Create the universal command with completion
api.nvim_create_user_command("Snacks", function(opts)
  local cmd = opts.fargs[1] -- The first word after :Snacks (e.g., 'grep')

  if not cmd then
    -- If no arguments, open the picker list (like :Telescope)
    Snacks.picker()
  elseif Snacks.picker[cmd] then
    -- If the subcommand exists (e.g., Snacks.picker.grep), call it
    Snacks.picker[cmd]()
  else
    vim.notify("Snacks: Picker '" .. cmd .. "' not found", vim.log.levels.ERROR)
  end
end, {
  nargs = "?", -- Allow zero or one argument
  desc = "Universal Snacks Picker Command",
  complete = function(arg_lead)
    -- This provides tab-completion for all available pickers
    local pickers = vim.tbl_keys(Snacks.picker)
    table.sort(pickers)
    return vim.tbl_filter(function(key)
      return key:match("^" .. arg_lead) and type(Snacks.picker[key]) == "function"
    end, pickers)
  end,
})

-- open NoNeckPain layout and run NoNeckPainResize with provided parameter
-- api.nvim_create_user_command(
--   "NNP",
--   function(opts)
--     assert(#opts.fargs > 0, "invalid params number: " .. #opts.fargs .. ", at least 1 argument required")
--     -- fetch the NoNeckPain config
--     local config = require("no-neck-pain").config
--     -- set the width
--     local ssize = opts.fargs[1]
--     local size = assert(tonumber(ssize), "invalid input: " .. ssize .. " is not a number")
--     config.width = size
--     -- set fileName of buffers if provided
--     local prefix = os.getenv("HOME") .. "/Desktop/nnp-notes/"
--     if #opts.fargs == 2 then
--       local name = prefix .. opts.fargs[2]
--       local buffers_config = config.buffers
--       for _, side in ipairs({ "left", "right" }) do
--         buffers_config[side].scratchPad.pathToFile = string.format("%s-%s.norg", name, side)
--       end
--     elseif #opts.fargs == 3 then
--       local lname = prefix .. opts.fargs[2] .. "-left.norg"
--       local rname = prefix .. opts.fargs[3] .. "-right.norg"
--       local buffers_config = config.buffers
--       buffers_config["left"].scratchPad.pathToFile  = lname
--       buffers_config["right"].scratchPad.pathToFile = rname
--     end
--     -- run NoNeckPain command
--     vim.cmd("NoNeckPain")
--   end,
--   {
--     nargs = "+",
--     desc = "Open NoNeckPain layout with provided width [and scratchPad name(s)] parameters",
--     complete = function(_, cmd, _)
--       local rfiles_set  = {}
--       local files_set   = {}
--       local i = string.find(cmd, "NNP")
--       if i == nil then return {} end
--       -- first argument was not set (width)
--       if string.match(cmd, "NNP%s+%d+%s+") == nil then return {} end
--       for file in io.popen('ls ${HOME}/Desktop/nnp-notes'):lines() do
--         local lfile = string.match(file, "(.*)-left.norg")
--         if lfile ~= nil then files_set[lfile]  = 1 end
--
--         local rfile = string.match(file, "(.*)-right.norg")
--         if rfile ~= nil then
--           files_set[rfile]  = 1
--           rfiles_set[rfile] = 1
--         end
--       end
--       local files = {}
--       for filename, _ in pairs(files_set) do
--         table.insert(files, filename)
--       end
--       -- second argument was not set (left filename / both)
--       if string.match(cmd, "NNP%s+%d+%s+%w+%s") == nil then return files end
--       local rfiles = {}
--       for filename, _ in pairs(rfiles_set) do
--         table.insert(rfiles, filename)
--       end
--       return rfiles
--     end
--   }
-- )

-- vim.api.nvim_create_autocmd("QuitPre", {
--   callback = function()
--     local _wins = {}
--     local floating_wins = {}
--     local wins = vim.api.nvim_list_wins()
--     for _, w in ipairs(wins) do
--       local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
--       if vim.api.nvim_win_get_config(w).relative ~= '' then
--         table.insert(floating_wins, w)
--       elseif (
--         bufname:match("NvimTree_") ~= nil
--         or bufname:match("OUTLINE_") ~= nil
--         or bufname == ""
--       ) then
--         table.insert(_wins, w)
--       end
--     end
--     if 1 == #wins - #floating_wins - #_wins then
--       -- Should quit, so we close all invalid windows.
--       for _, w in ipairs(_wins) do
--         vim.api.nvim_win_close(w, true)
--       end
--     end
--   end
-- })


-- api.nvim_del_user_command("NoNeckPain")
-- api.nvim_create_user_command(
--   "NoNeckPain",
--   function()
--     local state = require("no-neck-pain.state")
--
--     if state.has_tabs(state) and state.is_active_tab_registered(state) then
--       vim.opt.laststatus  = vim.g.statusline.laststatus
--       vim.opt.showtabline = 2
--     else
--       vim.opt.laststatus  = 0
--       vim.opt.showtabline = 0
--     end
--
--     require("no-neck-pain").toggle()
--   end,
--   { desc = "Toggles the plugin. // updated version" }
-- )

api.nvim_create_user_command(
  "RedrawLsp",
  function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled());
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled());
    require('symbol-usage').refresh();
  end,
  { desc = "toggles the inlay_hint" }
)

api.nvim_create_user_command(
  "Converturl",
  function() vim.fn.system('converturl') end,
  { desc = "convert the github URL using `converturl` shell command" }
)
