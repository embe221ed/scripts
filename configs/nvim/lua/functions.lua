-- open NoNeckPain layout and run NoNeckPainResize with provided parameter
vim.api.nvim_create_user_command(
  "NNP",
  function(opts)
    vim.cmd("NoNeckPain")
    local size = tonumber(opts.fargs[1])
    vim.cmd(string.format("NoNeckPainResize %d", size))
  end,
  {
    nargs = 1,
    desc = "Open NoNeckPain layout and run NoNeckPainResize with provided parameter",
  }
)
