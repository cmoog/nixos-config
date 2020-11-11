"" .vimrc configuration

" normal mode keymaps
inoremap jj <ESC>
inoremap jk <ESC>

" syntax highlighting
syntax on
set bg=dark

" allow scrolling with mouse
:set mouse=a

" set line number option
set number

" tab size
set ts=4 sw=4

" set cursor styles during normal and insert modes
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" use system clipboard
set clipboard=unnamed

" set cursor styles during normal and insert moddes NOT MacOS + iTerm2 
:autocmd InsertEnter * set cul
:autocmd InsertLeave * set nocul

" switching between tabs
nnoremap H gT
nnoremap L gt

set timeoutlen=1000
set ttimeoutlen=0
set visualbell

set colorcolumn=120
highlight ColorColumn ctermbg=0 guibg=lightgrey

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

Plugin 'rust-lang/rust.vim'

let g:fzf_preview_window = 'right:60%'
noremap <C-t> :tabnew<CR>
nnoremap <silent> <C-p> :FZF<CR>
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
Plugin 'junegunn/fzf'

" status bar interface
let g:airline_theme = 'gruvbox' 

" Plugin 'valloric/youcompleteme'

Plugin 'airblade/vim-gitgutter'

Plugin 'morhetz/gruvbox'
set bg=dark
let g:gruvbox_contrast_dark = "hard" " soft, medium, hard
autocmd vimenter * colorscheme gruvbox

" for showing a different cursor in insert mode
autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul

call vundle#end()            " required
filetype plugin indent on    " required

