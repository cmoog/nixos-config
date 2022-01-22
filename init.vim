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
	Plug 'neovim/nvim-lspconfig'
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/cmp-buffer'
	Plug 'hrsh7th/cmp-path'
	Plug 'hrsh7th/cmp-cmdline'
	Plug 'hrsh7th/nvim-cmp'

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

let g:lightline = {}
let g:lightline.colorscheme = 'ghdark'
colorscheme ghdark

set completeopt=menu,menuone,noselect

lua <<EOF
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
	local cmp = require'cmp'

	cmp.setup({
		snippet = {
		expand = function(args)
		end,
		},
		mapping = {
		['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
		['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
		['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
		['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		['<C-e>'] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		},
		sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' }, -- For vsnip users.
		}, {
		{ name = 'buffer' },
		})
	})

	cmp.setup.cmdline('/', {
		sources = {
		{ name = 'buffer' }
		}
	})

	cmp.setup.cmdline(':', {
		sources = cmp.config.sources({
		{ name = 'path' }
		}, {
		{ name = 'cmdline' }
		})
	})

	local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

	local nvim_lsp = require('lspconfig')

	nvim_lsp.gopls.setup{capabilities = capabilities}
	nvim_lsp.rust_analyzer.setup{capabilities = capabilities}
	nvim_lsp.pyright.setup{capabilities = capabilities}
	nvim_lsp.hls.setup{capabilities = capabilities}

	nvim_lsp.denols.setup {
		root_dir = nvim_lsp.util.root_pattern("mod.ts", "mod.js"),
		init_options = { lint = true, },
		capabilities = capabilities,
	}

	nvim_lsp.tsserver.setup {
		root_dir = nvim_lsp.util.root_pattern("package.json"),
		init_options = { lint = true, },
		capabilities = capabilities,
	}
EOF
