" neovim config

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

call plug#begin('~/.local/share/nvim/plugged')
	Plug 'airblade/vim-gitgutter'
	Plug 'APZelos/blamer.nvim'
	Plug 'cespare/vim-toml'
	Plug 'dag/vim-fish'
	Plug 'fatih/vim-go'
	Plug 'folke/lsp-colors.nvim'
	Plug 'itchyny/lightline.vim'
	Plug 'jiangmiao/auto-pairs'
	Plug 'junegunn/fzf.vim'
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'mattn/emmet-vim'
	Plug 'neovim/nvim-lspconfig'
	Plug 'nvim-lua/completion-nvim'
	Plug 'nvim-treesitter/nvim-treesitter'
	Plug 'preservim/nerdtree'
	Plug 'rust-lang/rust.vim'
	Plug 'wojciechkepka/vim-github-dark'
call plug#end()

set updatetime=1000
set completeopt=menuone,noselect
nnoremap <silent> <C-p> :FZF<CR>
let g:netrw_liststyle = 3

let g:blamer_enabled = 1
let g:rustfmt_autosave = 1

" Start NERDTree when neovim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Exit neovim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

" Mirror the NERDTree before showing it. This makes it the same on all tabs.
nnoremap <C-b> :NERDTreeMirror<CR>:NERDTreeToggle<CR>

lua << EOF
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
	require('completion').on_attach()

	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings
	local opts = { noremap=true, silent=true }
	buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
	buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

	-- Set some keybinds conditional on server capabilities
	if client.resolved_capabilities.document_formatting then
		buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	elseif client.resolved_capabilities.document_range_formatting then
		buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	end
end

nvim_lsp.gopls.setup{on_attach=on_attach}
nvim_lsp.rust_analyzer.setup{on_attach=on_attach}
nvim_lsp.tsserver.setup{on_attach=on_attach}
nvim_lsp.pyright.setup{on_attach=on_attach}
nvim_lsp.hls.setup{on_attach=on_attach}

require("lsp-colors").setup({
	Error = "#db4b4b",
	Warning = "#e0af68",
	Information = "#0db9d7",
	Hint = "#10B981"
})

require('nvim-treesitter.configs').setup({
	highlight = {
		enable = true
	},
})
EOF

let g:lightline = {}
let g:lightline.colorscheme = 'ghdark'
colorscheme ghdark
