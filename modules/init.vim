" init.vim configuration

" normal mode keymaps
inoremap jj <ESC>
inoremap jk <ESC>

" up/down navigation mapped to lines as *displayed*
noremap <silent> k gk
noremap <silent> j gj

" switching between tabs
nnoremap <C-h> gT
nnoremap <C-l> gt

syntax enable
set autoindent
set clipboard=unnamed
set cmdheight=1
set conceallevel=0
set cursorline
set encoding=utf-8
set expandtab
set fileencoding=utf-8
set filetype=on
set mouse=a
set nocompatible
set noshowmode
set wrap
set number
set ruler
set shiftwidth=2
set showtabline=2
set smartindent
set smarttab
set splitbelow
set splitright
set t_Co=256
set tabstop=2
set timeoutlen=1000
set ttimeoutlen=0
set backspace=indent,eol,start

" wrap after col 100 for these file extensions
au BufRead,BufNewFile *.md,*.txt,*.tex,*.cls setlocal textwidth=100
set formatoptions+=t
set formatoptions-=l
set linebreak

set background=dark
