"" .vimrc configuration

" normal mode keymaps
inoremap jj <ESC>
inoremap jk <ESC>

" syntax highlighting
syntax on

" allow scrolling with mouse
:set mouse=a

" set line number option
set number

" for switching between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set timeoutlen=1000
set ttimeoutlen=0
set visualbell

"" ================= PLUGINS =================

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'fatih/vim-go'
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1
au filetype go inoremap <buffer> . .<C-x><C-o>

" status bar interface
let g:airline_theme = 'gruvbox' 

" Plugin 'valloric/youcompleteme'

Plugin 'airblade/vim-gitgutter'
set updatetime=1000 " for gitgutter configuration

Plugin 'morhetz/gruvbox'
autocmd vimenter * colorscheme gruvbox

" for showing a different cursor in insert mode
autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul

call vundle#end()            " required
filetype plugin indent on    " required

" ============== PLUGIN CONFIG =================
