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

set autoindent
set backspace=indent,eol,start
set clipboard=unnamed
set conceallevel=0
set cursorline
set encoding=utf-8
set expandtab
set fileencoding=utf-8
set filetype=on
set mouse=a
set nocompatible
set noshowmode
set number
set ruler
set shiftwidth=2
set splitbelow
set splitright
set t_Co=256
set tabstop=2
set timeoutlen=1000
set ttimeoutlen=0
set wrap
syntax enable

" error color for tailing whitespace
match errorMsg /\s\+$/

" prefer to keep cursor in middle of buffer
set so=999

" wrap after col 100 for these file extensions
autocmd BufRead,BufNewFile *.md,*.txt,*.tex,*.cls setlocal textwidth=100 spell spelllang=en_us
autocmd BufRead,BufNewFile *.typ setlocal textwidth=100 filetype=typst
autocmd FileType tex,gitcommit setlocal spell spelllang=en_us
set formatoptions+=t
set formatoptions-=l
set linebreak

set background=dark
