require("quicker").setup({
  -- This ensures Quicker stays as a 'local' split under your editor
  -- and doesn't squash your NvimTree
  constrain_cursor = true,
  highlight = {
    treesitter = true, -- Modern 2026 syntax highlighting
    lsp = true,
  },
})
