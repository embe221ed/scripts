local globals = require('globals')

vim.cmd [[ highlight IndentBlanklineChar                guifg=#51576d ]]
vim.cmd [[ highlight IndentBlanklineSpaceChar           guifg=#51576d ]]
vim.cmd [[ highlight IndentBlanklineSpaceCharBlankline  guifg=#51576d ]]
vim.cmd [[ highlight NormalFloat                        guibg=combine ]]

-- Bufferline offsets
-- Outline and NvimTree
if globals.current_theme == "macchiato" then
  -- macchiato
  vim.cmd [[ highlight BufferlineOffsetTitleBase          cterm=bold gui=bold guifg=#8aadf4 guibg=#1e2030 ]]
  vim.cmd [[ highlight BufferlineOffsetTitleBright        cterm=bold gui=bold guifg=#8aadf4 guibg=#1e2030 ]]
  vim.cmd [[ highlight TreesitterContextBottom            gui=underline, guisp=#494d64                    ]]
elseif globals.current_theme == "latte" then
  -- latte
  vim.cmd [[ highlight BufferlineOffsetTitleBase          cterm=bold gui=bold guifg=#1e66f5 guibg=#e6e9ef ]]
  vim.cmd [[ highlight BufferlineOffsetTitleBright        cterm=bold gui=bold guifg=#1e66f5 guibg=#e6e9ef ]]
  vim.cmd [[ highlight TreesitterContextBottom            gui=underline, guisp=#bcc0cc                    ]]
elseif globals.current_theme == "frappe" then
  -- latte
  vim.cmd [[ highlight BufferlineOffsetTitleBase          cterm=bold gui=bold guifg=#8caaee guibg=#292c3c ]]
  vim.cmd [[ highlight BufferlineOffsetTitleBright        cterm=bold gui=bold guifg=#8caaee guibg=#292c3c ]]
  vim.cmd [[ highlight TreesitterContextBottom            gui=underline, guisp=#51576d                    ]]
end
