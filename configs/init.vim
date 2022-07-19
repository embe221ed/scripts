call plug#begin('~/.local/share/nvim/plugged')

Plug 'Shougo/ddc.vim'
Plug 'vim-denops/denops.vim'
" Install your sources
Plug 'Shougo/ddc-around'
" Install your filters
Plug 'Shougo/ddc-matcher_head'
Plug 'Shougo/ddc-sorter_rank'
" Install LSP
Plug 'Shougo/ddc-nvim-lsp'
Plug 'neovim/nvim-lspconfig'
Plug 'Shougo/pum.vim'
Plug 'ray-x/lsp_signature.nvim'

Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'neomake/neomake'
Plug 'machakann/vim-highlightedyank'
Plug 'tmhedberg/SimpylFold'
Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' }
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'ryanoasis/vim-devicons'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'marko-cerovac/material.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'akinsho/bufferline.nvim'
Plug 'Xuyuanp/nerdtree-git-plugin'

call plug#end()

" Plugins config
let g:material_style = "palenight"
let g:semshi#excluded_hl_groups = ['local', 'unresolved']
let g:semshi#always_update_all_highlights = v:true
" Customize global settings
" Use around source.
" https://github.com/Shougo/ddc-around
call ddc#custom#patch_global('sources', ['nvim-lsp', 'around'])
call ddc#custom#patch_global('completionMenu', 'pum.vim')
call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
      \   'matchers': ['matcher_head'],
      \   'sorters': ['sorter_rank']},
      \   'around': {'mark': 'A'}
      \ })

let g:neomake_python_enabled_makers = ['pylint']
let g:NERDTreeGitStatusUseNerdFonts = 1 " you should install nerdfonts by yourself. default: 0

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = {
    \ 'python': {'left': '#'},
    \ 'c': {'left': '//', 'leftAlt': '/*', 'rightAlt': '*/'},
    \ 'java': {'left': '//', 'leftAlt': '/*', 'rightAlt': '*/'} 
    \ }
" Disallow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 0
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
"end of plugins config

set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching 
set ignorecase              " case insensitive 
set mouse=v                 " middle-click paste with 
set hlsearch                " highlight search 
set incsearch               " incremental search
set tabstop=4               " number of columns occupied by a tab 
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set smartindent
set number                  " add line numbers
set relativenumber	        " add relative numbers
set splitright
set splitbelow
set termguicolors
" set wildmode=longest,list   " get bash-like tab completions
filetype plugin indent on   "allow auto-indenting depending on file type
syntax on                   " syntax highlighting
set clipboard=unnamedplus   " using system clipboard
filetype plugin on
set cursorline              " highlight current cursorline
set ttyfast                 " Speed up scrolling in Vim
" set spell                 " enable spell check (may need to download language package)
" set noswapfile            " disable creating swap file
" set backupdir=~/.cache/vim " Directory to store backup files.

" airline
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
 endif

let g:airline_symbols.colnr = "\u33c7"

" mappings
nnoremap <C-n>  :NERDTreeToggle<CR>
nnoremap <C-h>  <C-w>h
nnoremap <C-l>  <C-w>l
nnoremap <C-k>  <C-w>k
nnoremap <C-j>  <C-w>j
nnoremap <C-b>  :bnext<CR>
nnoremap <C-p>  :bprev<CR>
inoremap <C-n>   <Cmd>call pum#map#select_relative(+1)<CR>
inoremap <C-p>   <Cmd>call pum#map#select_relative(-1)<CR>
inoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
inoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
nnoremap <silent> K         <Cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>i <Cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <leader>d <Cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>D <Cmd>lua vim.lsp.buf.declaration()<CR>
inoremap <expr> <CR> pum#visible() ? (pum#complete_info().selected == -1 ? '<Cmd>call pum#map#confirm()<CR><CR>' : '<Cmd>call pum#map#confirm()<CR>') : '<CR>'
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!

" autocmd
" Start NERDTree and put the cursor back in the other window.
autocmd VimEnter * NERDTree | wincmd p
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" LUA config
lua << END
require('bufferline').setup {
    options = {
        numbers = 'buffer_id'
    }
}
require('lualine').setup {
    options = {
        theme = 'material-stealth'
    }
}
require('material').setup {
    disable = {
        background = true
    },
    italics = {
        comments = true,
        keywords = true,
        functions = true,
        strings = true,
        variables = true
    }
}
local cfg = {
    hint_enable = false,
    handler_opts = { border = "rounded" },
    max_width = 200
}
require('lsp_signature').setup(cfg)
require('lspconfig').jedi_language_server.setup {}
require('lspconfig').clangd.setup {}
require('lspconfig').java_language_server.setup {
    cmd = {"/opt/java-language-server/dist/lang_server_linux.sh"}
}
END

colorscheme material
call ddc#enable()
