-- open NoNeckPain layout and run NoNeckPainResize with provided parameter
vim.api.nvim_create_user_command(
  "NNP",
  function(opts)
    local palette = require("catppuccin.palettes").get_palette("macchiato")
    assert(#opts.fargs > 0, "invalid params number: " .. #opts.fargs .. ", at least 1 argument required")
    if #opts.fargs == 2 then
      local name = opts.fargs[2]
      require("no-neck-pain").setup({
        buffers = {
          colors = {
            -- Hexadecimal color code to override the current background color of the buffer. (e.g. #24273A)
            -- Transparent backgrounds are supported by default.
            --- @type string?
            background = palette.crust,
            -- Brighten (positive) or darken (negative) the side buffers background color. Accepted values are [-1..1].
            --- @type integer
            -- blend = -0.2,
          },
          scratchPad = {
            -- When `true`, automatically sets the following options to the side buffers:
            -- - `autowriteall`
            -- - `autoread`.
            --- @type boolean
            enabled = true,
            -- set to `nil` to default 
            -- to current working directory
            location = nil,
            -- The name of the generated file. See `location` for more information.
            --- @type string
            --- @example: `no-neck-pain-left.norg`
            fileName = name,
          },
          bo = {
            filetype = "nnp",
          },
        },
      })
    end
    vim.cmd("NoNeckPain")
    local ssize = opts.fargs[1]
    local size = assert(tonumber(ssize), "invalid input: " .. ssize .. " is not a number")
    vim.cmd(string.format("NoNeckPainResize %d", size))
  end,
  {
    nargs = "+",
    desc = "Open NoNeckPain layout and run NoNeckPainResize with provided parameter",
  }
)
