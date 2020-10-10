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

" set cursor styles during normal and insert modes on MacOS iTerm2
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

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

let g:fzf_preview_window = 'right:60%'
noremap <C-t> :tabnew<CR>
nnoremap <silent> <C-p> :FZF<CR>
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
Plugin 'junegunn/fzf'

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
