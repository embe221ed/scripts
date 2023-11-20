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
  }
)
