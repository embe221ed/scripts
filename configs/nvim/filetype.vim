" my filetype file
if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au! BufRead,BufNewFile *.move                setfiletype move
  au! BufRead,BufNewFile *.mvir                setfiletype rust
augroup END
