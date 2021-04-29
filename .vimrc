"" .vimrc configuration

" normal mode keymaps
inoremap jj <ESC>
inoremap jk <ESC>

syntax on             " syntax highlighting
set mouse=a           " allow scrolling with mouse
set number            " set line number option
set ts=4 sw=4         " tab size
set clipboard=unnamed " use system clipboard
set timeoutlen=1000
set ttimeoutlen=0
set visualbell

" set cursor styles during normal and insert modes
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" set cursor styles during normal and insert modes NOT MacOS + iTerm2
autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul

" switching between tabs
nnoremap H gT
nnoremap L gt

set colorcolumn=120
highlight ColorColumn ctermbg=0 guibg=lightgrey
set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'fatih/vim-go'
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1
au filetype go inoremap <buffer> . .<C-x><C-o>

Plugin 'rust-lang/rust.vim'
Plugin 'prabirshrestha/vim-lsp'

let g:fzf_preview_window = 'right:60%'
noremap <C-t> :tabnew<CR>
nnoremap <silent> <C-p> :FZF<CR>
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
Plugin 'junegunn/fzf'

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'airblade/vim-gitgutter'
Plugin 'morhetz/gruvbox'
Plugin 'ycm-core/YouCompleteMe'


call vundle#end()

set bg=dark
let g:gruvbox_contrast_dark = "hard" " soft, medium, hard
colorscheme gruvbox
let g:airline_theme = 'gruvbox'

