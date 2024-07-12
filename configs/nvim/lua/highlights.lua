local globals = require('globals')

vim.cmd [[ highlight TreesitterContext                  guibg=combine ]]
vim.cmd [[ highlight TreesitterContextBottom            guibg=combine cterm=NONE gui=NONE ]]
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
  vim.cmd [[ highlight TreesitterContextLineNumber        cterm=bold gui=bold guifg=#a5adce guibg=#24273a ]]
elseif globals.current_theme == "latte" then
  -- latte
  vim.cmd [[ highlight BufferlineOffsetTitleBase          cterm=bold gui=bold guifg=#1e66f5 guibg=#e6e9ef ]]
  vim.cmd [[ highlight BufferlineOffsetTitleBright        cterm=bold gui=bold guifg=#1e66f5 guibg=#e6e9ef ]]
  vim.cmd [[ highlight TreesitterContextLineNumber        cterm=bold gui=bold guifg=#6c6f85 guibg=#eff1f5 ]]
elseif globals.current_theme == "frappe" then
  -- latte
  vim.cmd [[ highlight BufferlineOffsetTitleBase          cterm=bold gui=bold guifg=#8caaee guibg=#292c3c ]]
  vim.cmd [[ highlight BufferlineOffsetTitleBright        cterm=bold gui=bold guifg=#8caaee guibg=#292c3c ]]
  vim.cmd [[ highlight TreesitterContextLineNumber        cterm=bold gui=bold guifg=#a5adce guibg=#303446 ]]
end
