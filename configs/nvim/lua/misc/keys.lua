--[[ keys.lua ]]
local map = vim.keymap.set

-- Toggle SymbolsOutline
map('n', '<C-s>', '<cmd>Outline!<CR>')

-- Window movement/management
map('n', '<C-J>', '<C-w>j')
map('n', '<C-K>', '<C-w>k')
map('n', '<C-L>', '<C-w>l')
map('n', '<C-H>', '<C-w>h')
map('n', '-', '<C-w>-')
map('n', '+', '<C-w>+')

-- buffer management
map('n', 'gb]', '<cmd>BufferLineCycleNext<CR>')
map('n', 'gb[', '<cmd>BufferLineCyclePrev<CR>')
map('n', 'gbx', '<cmd>BufferLinePickClose<CR>')
map('n', 'gbp', '<cmd>BufferLinePick<CR>')

-- terminal
map('t', '<Esc>', [[<C-\><C-n>]])
map('t', '<C-J>', [[<C-\><C-n><C-w>j]])
map('t', '<C-K>', [[<C-\><C-n><C-w>k]])
map('t', '<C-L>', [[<C-\><C-n><C-w>l]])
map('t', '<C-H>', [[<C-\><C-n><C-w>h]])

-- remap search keys to put the result in the middle
map('n', 'n', 'nzz')
map('n', 'N', 'Nzz')
map('n', '*', '*zz')
map('n', '#', '#zz')
map('n', 'g*', 'g*zz')
map('n', 'g#', 'g#zz')

-- bookmarks (LintaoAmons/bookmarks.nvim)
map('n', '<space>bm', '<cmd>BookmarksMark<cr>', { desc = "Bookmark: mark line" })
map('n', '<space>bl', '<cmd>BookmarksGoto<cr>', { desc = "Bookmark: goto / list" })
map('n', '<space>bt', '<cmd>BookmarksTree<cr>', { desc = "Bookmark: tree view" })

-- LSP reference navigation via snacks.words (highlight symbol under cursor + hop)
map('n', ']]', function() Snacks.words.jump(vim.v.count1, true) end,  { desc = "Next reference" })
map('n', '[[', function() Snacks.words.jump(-vim.v.count1, true) end, { desc = "Prev reference" })

-- native treesitter structural inspection
map('n', '<space>ti', function() vim.treesitter.inspect_tree() end, { desc = "Inspect syntax tree" })
map('n', '<space>tq', '<cmd>EditQuery<cr>',                         { desc = "Edit treesitter query" })
map('n', '<space>tk', '<cmd>Inspect<cr>',                          { desc = "Inspect item under cursor" })

-- diagnostic / inlay-hint / virtual-line toggles
map('n', '<space>ud', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { desc = "Toggle diagnostics" })
map('n', '<space>uh', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, { desc = "Toggle inlay hints" })
map('n', '<space>uv', function()
  local cfg = vim.diagnostic.config()
  vim.diagnostic.config({ virtual_lines = cfg.virtual_lines and false or { current_line = true } })
end, { desc = "Toggle virtual_lines" })

-- pickers (snacks) — find & search
map('n', '<space>ff', function() Snacks.picker.smart() end,                 { desc = "Find files (smart)" })
map('n', '<space>fb', function() Snacks.picker.buffers() end,               { desc = "Buffers" })
map('n', '<space>fr', function() Snacks.picker.recent() end,                { desc = "Recent files" })
map('n', '<space>/',  function() Snacks.picker.grep() end,                  { desc = "Live grep" })
map({'n','x'}, '<space>sw', function() Snacks.picker.grep_word() end,       { desc = "Grep word / selection" })
map('n', '<space>ss', function() Snacks.picker.lsp_symbols() end,           { desc = "Document symbols" })
map('n', '<space>sS', function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Workspace symbols" })
map('n', '<space>sr', function() Snacks.picker.resume() end,                { desc = "Resume picker" })
map('n', '<space>su', function() Snacks.picker.undo() end,                  { desc = "Undo history" })
map('n', '<space>sG', function() Snacks.picker.git_status() end,            { desc = "Git status" })

-- profiler (snacks)
map('n', '<space>pp', function() Snacks.profiler.toggle() end,  { desc = "Profiler toggle" })
map('n', '<space>ps', function() Snacks.profiler.scratch() end, { desc = "Profiler scratch" })
