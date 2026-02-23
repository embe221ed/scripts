local api = vim.api

api.nvim_create_user_command('Markserv', '!tmux new -d "source ~/.nvm/nvm.sh && nvm use node && markserv . --silent"', {})

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

api.nvim_create_user_command(
  "RedrawLsp",
  function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled());
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled());
    vim.diagnostic.reset();
    require('symbol-usage').refresh();
  end,
  { desc = "toggles the inlay_hint" }
)

api.nvim_create_user_command(
  "Converturl",
  function() vim.fn.system('converturl') end,
  { desc = "convert the github URL using `converturl` shell command" }
)
