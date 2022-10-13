--[[ keys.lua ]]
local map = vim.api.nvim_set_keymap

-- remap the key used to leave insert mode
map('i', 'jk', '<Esc>', {})

-- Toggle nvim-tree
map('n', '<C-n>', [[:NvimTreeToggle<CR>]], {})

-- Toggle SymbolsOutline
map('n', '<C-s>', [[:SymbolsOutline<CR>]], {})

-- Window movement
map('n', '<C-J>', [[<C-w>j]], {})
map('n', '<C-K>', [[<C-w>k]], {})
map('n', '<C-L>', [[<C-w>l]], {})
map('n', '<C-H>', [[<C-w>h]], {})

-- buffer movement
map('n', 'b]', [[:BufferLineCycleNext<CR>]], {})
map('n', 'b[', [[:BufferLineCyclePrev<CR>]], {})
