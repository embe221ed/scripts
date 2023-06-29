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

-- buffer management
map('n', 'b]', [[:BufferLineCycleNext<CR>]], {})
map('n', 'b[', [[:BufferLineCyclePrev<CR>]], {})
map('n', 'bx', [[:BufferLinePickClose<CR>]], {})
map('n', 'bp', [[:BufferLinePick<CR>]], {})

-- terminal
-- :tnoremap <Esc> <C-\><C-n>
map('t', '<Esc>', [[<C-\><C-n>]], {})
map('t', '<C-J>', [[<C-\><C-n><C-w>j]], {})
map('t', '<C-K>', [[<C-\><C-n><C-w>k]], {})
map('t', '<C-L>', [[<C-\><C-n><C-w>l]], {})
map('t', '<C-H>', [[<C-\><C-n><C-w>h]], {})

-- remap search keys to put the result in the middle
map('n', 'n', 'nzz', {})
map('n', 'N', 'Nzz', {})
map('n', '*', '*zz', {})
map('n', '#', '#zz', {})
map('n', 'g*', 'g*zz', {})
map('n', '#', 'g#zz', {})
