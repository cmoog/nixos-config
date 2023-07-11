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

set background=dark

lua <<EOF
  -- fzf file search
  vim.api.nvim_set_keymap("n", "<C-p>", "<cmd>:Files<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<C-m>", "<cmd>:Rg<CR>", { noremap = true, silent = true })
  -- fzf dirty files  
  vim.api.nvim_set_keymap("n", "<C-f>", "<cmd>:GFiles?<CR>", { noremap = true, silent = true })

  -- file explorer
  vim.api.nvim_set_keymap("n", "<C-b>", "<cmd>:NvimTreeToggle<CR>", { noremap = true, silent = true })

  -- new tabs
  vim.api.nvim_set_keymap("n", "<C-t>", "<cmd>:tabnew<CR>", { noremap = true, silent = true })

  require('toggleterm').setup{
    size = 15,
    -- bottom terminal
    open_mapping = [[<C-j>]],
  }
  local Terminal  = require('toggleterm.terminal').Terminal

  -- floating terminal
  local floating = Terminal:new({ direction = "float", hidden = true })
  function _floating_toggle()
    floating:toggle()
  end
  vim.api.nvim_set_keymap("n", "<C-\\>", "<cmd>lua _floating_toggle()<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("t", "<C-\\>", "<cmd>lua _floating_toggle()<CR>", { noremap = true, silent = true })

  -- lazygit floating terminal
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
  require('github-theme').setup({
    options = {
      styles = {
        keywords = 'NONE'
      }
    }
  })

  vim.cmd('colorscheme github_dark_high_contrast')
  require('lualine').setup({
    options = {
      -- alacritty doesn't support ligatures
      icons_enabled = false,
    },
  })
  require('gitsigns').setup({
    current_line_blame = true,
    current_line_blame_opts = { delay = 2000, },
  })
  require("nvim-tree").setup({
    renderer = {
      icons = {
        show = { file = false, folder = false, folder_arrow = false, },
      },
    },
  })
EOF
