"" init.vim configuration

" normal mode keymaps
inoremap jj <ESC>
inoremap jk <ESC>

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
set nowrap
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
set visualbell
set backspace=indent,eol,start

" set cursor styles during normal and insert modes
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" switching between tabs
nnoremap H gT
nnoremap L gt

noremap <C-t> :tabnew<CR>
" fzf file search
nnoremap <silent> <C-p> :FZF<CR>

" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

" Mirror the NERDTree before showing it. This makes it the same on all tabs.
nnoremap <C-b> :NERDTreeMirror<CR>:NERDTreeToggle<CR>

" color scheme
set bg=dark
let g:gruvbox_contrast_dark='hard' " soft, medium, hard
colorscheme gruvbox
let g:airline_theme = 'gruvbox'

lua <<EOF
  require('nvim-autopairs').setup{}
  require('nvim-treesitter.configs').setup({
    highlight = {
      enable = true,
    },
    indent = {
      enable = true
    },
  })
EOF
