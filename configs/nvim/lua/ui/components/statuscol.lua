local builtin = require('statuscol.builtin')

require('gitsigns').setup()

require("statuscol").setup({
  segments = {
    { text = { " " } },
    { text = { "%s" }, click = "v:lua.ScSa" },
    {
      text = { builtin.lnumfunc, " " },
      condition = { true, builtin.not_empty },
      click = "v:lua.ScLa",
    },
    { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
    { text = { " " } },
  },
})
