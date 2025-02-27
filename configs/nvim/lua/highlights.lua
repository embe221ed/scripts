vim.cmd [[ highlight IndentBlanklineChar                guifg=#51576d ]]
vim.cmd [[ highlight IndentBlanklineSpaceChar           guifg=#51576d ]]
vim.cmd [[ highlight IndentBlanklineSpaceCharBlankline  guifg=#51576d ]]
vim.cmd [[ highlight NormalFloat                        guibg=combine ]]

-- Bufferline offsets
-- Outline and NvimTree
if vim.g.colorscheme.theme == "storm" then
  -- latte
  vim.cmd [[ highlight BufferlineOffsetTitleBase          cterm=bold gui=bold guifg=#8caaee guibg=#1f2335 ]]
  vim.cmd [[ highlight BufferlineOffsetTitleBright        cterm=bold gui=bold guifg=#8caaee guibg=#1f2335 ]]
  vim.cmd [[ highlight TreesitterContextBottom            gui=underline, guisp=#51576d                    ]]
elseif vim.g.colorscheme.theme == "day" then
  -- latte
  vim.cmd [[ highlight BufferlineOffsetTitleBase          cterm=bold gui=bold guifg=#8caaee guibg=#d5d9e7 ]]
  vim.cmd [[ highlight BufferlineOffsetTitleBright        cterm=bold gui=bold guifg=#8caaee guibg=#d5d9e7 ]]
  vim.cmd [[ highlight TreesitterContextBottom            gui=underline, guisp=#a8aecb                    ]]
end
