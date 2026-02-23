return {
  "folke/snacks.nvim",
  opts = {
    input = {},
    zen = {},
    picker = {
      layout = {
        layout = {
          backdrop = vim.g.neovide or vim.g.border == "none",
        },
      },
      sources = {
        explorer = {
          layout = { preset = "default", preview = true },
          auto_close = true,
        }
      },
    },
  },
}
