" init.vim configuration

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

" up/down navigation mapped to lines as *displayed*
noremap <silent> k gk
noremap <silent> j gj

" wrap after col 100 for these file extensions
au BufRead,BufNewFile *.md,*.txt,*.tex,*.cls setlocal textwidth=100
set formatoptions+=t
set formatoptions-=l
set linebreak

" switching between tabs
nnoremap <C-h> gT
nnoremap <C-l> gt

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
  \ quit | endif

" Mirror the NERDTree before showing it. This makes it the same on all tabs.
nnoremap <C-b> :NERDTreeMirror<CR>:NERDTreeToggle<CR>

" color scheme
set background=dark
let g:gruvbox_contrast_dark='hard' " soft, medium, hard
let g:airline_theme = 'gruvbox'
colorscheme gruvbox

lua <<EOF
  -- fzf file search
  vim.api.nvim_set_keymap("n", "<C-p>", "<cmd>:FZF<CR>", { noremap = true, silent = true })

  -- new tabs
  vim.api.nvim_set_keymap("n", "<C-t>", "<cmd>:tabnew<CR>", { noremap = true, silent = true })

  require('toggleterm').setup{
    size = 15,
    open_mapping = [[<C-j>]],
  }
  local Terminal  = require('toggleterm.terminal').Terminal

  -- <C-\> for a floating terminal
  local floating = Terminal:new({ direction = "float", hidden = true })
  function _floating_toggle()
    floating:toggle()
  end
  vim.api.nvim_set_keymap("n", "<C-\\>", "<cmd>lua _floating_toggle()<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("t", "<C-\\>", "<cmd>lua _floating_toggle()<CR>", { noremap = true, silent = true })

  -- <C-g> for a lazygit floating terminal
  local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })
  function _lazygit_toggle()
    lazygit:toggle()
  end
  vim.api.nvim_set_keymap("n", "<C-g>", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("t", "<C-g>", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })

  require('nvim-autopairs').setup{}
  require('nvim-treesitter.configs').setup({
    highlight = {
      enable = true
    },
    indent = {
      enable = true
    },
  })
EOF
