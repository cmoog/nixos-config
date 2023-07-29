-- fzf file search
vim.api.nvim_set_keymap("n", "<C-p>", "<cmd>:Files<CR>", { noremap = true, silent = true })
-- fzf dirty files  
vim.api.nvim_set_keymap("n", "<C-f>", "<cmd>:GFiles?<CR>", { noremap = true, silent = true })

-- file explorer
vim.api.nvim_set_keymap("n", "<C-b>", "<cmd>:NvimTreeToggle<CR>", { noremap = true, silent = true })

-- new tabs
vim.api.nvim_set_keymap("n", "<C-t>", "<cmd>:tabnew<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<S-h>", "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })

require('toggleterm').setup{
  size = 15,
  -- bottom terminal
  open_mapping = [[<C-j>]],
}
local Terminal = require('toggleterm.terminal').Terminal

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

-- highlight with treesitter semantics
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
      -- disable italic keywords
      keywords = 'NONE'
    }
  }
})

vim.cmd('colorscheme github_dark_high_contrast')

-- detect tabs/spaces indent style
require('guess-indent').setup()

-- bottom status bar
require('lualine').setup({
  options = {
    -- alacritty doesn't support ligatures
    icons_enabled = false,
  },
  sections = {
    lualine_c = {'filename', 'lsp_progress'},
    -- 'hostname' instead of default that shows 'unix'
    lualine_x = {'hostname', 'encoding', 'filetype'},
  },
})

-- git status in gutter
require('gitsigns').setup({
  current_line_blame = true,
  current_line_blame_opts = { delay = 2000, },
})

-- file explorer
require('nvim-tree').setup({
  renderer = {
    icons = {
      show = { file = false, folder = false, folder_arrow = false, },
    },
  },
})

-- language server setup
local lsp = require('lspconfig')
lsp.nil_ls.setup({ capabilities = capabilities })
lsp.rust_analyzer.setup({})
lsp.gopls.setup({})
lsp.hls.setup({
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
})

