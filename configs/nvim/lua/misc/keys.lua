--[[ keys.lua ]]
local map = vim.keymap.set

-- Toggle nvim-tree
map('n', '<C-n>', '<cmd>NvimTreeToggle<CR>')

-- Toggle SymbolsOutline
map('n', '<C-s>', '<cmd>Outline!<CR>')

-- Window movement/management
map('n', '<C-J>', '<C-w>j')
map('n', '<C-K>', '<C-w>k')
map('n', '<C-L>', '<C-w>l')
map('n', '<C-H>', '<C-w>h')
map('n', '-', '<C-w>-')
map('n', '+', '<C-w>+')
map('n', '=', '<C-w>+')

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
