-- fzf file search
local fzf = require("fzf-lua")
vim.keymap.set("n", "<C-p>", fzf.files)
vim.keymap.set("n", "<C-r>", fzf.git_status)
vim.keymap.set("n", "<C-f>", fzf.grep)

-- file explorer
vim.api.nvim_set_keymap("n", "<C-b>", "<cmd>:NvimTreeToggle<CR>",
                        {noremap = true, silent = true})

-- new tabs
vim.keymap.set("n", "<C-t>", "<cmd>:tabnew<CR>")

require("toggleterm").setup({
    size = 15,
    -- bottom terminal
    open_mapping = [[<C-j>]]
})
local Terminal = require("toggleterm.terminal").Terminal

-- floating terminal
local floating = Terminal:new({direction = "float", hidden = true})
function _floating_toggle() floating:toggle() end
vim.keymap.set("n", "<C-\\>", _floating_toggle)
vim.keymap.set("t", "<C-\\>", _floating_toggle)

-- lazygit floating terminal
local lazygit = Terminal:new({
    cmd = "lazygit",
    direction = "float",
    hidden = true
})
function _lazygit_toggle() lazygit:toggle() end
vim.keymap.set("n", "<C-g>", _lazygit_toggle)
vim.keymap.set("t", "<C-g>", _lazygit_toggle)

-- bracket/brace matching
require("nvim-autopairs").setup()

-- highlight with treesitter semantics
require("nvim-treesitter.configs").setup({
    highlight = {enable = true},
    indent = {enable = true}
})

require("github-theme").setup({
    options = {
        styles = {
            -- disable italic keywords
            keywords = "NONE"
        }
    }
})

vim.cmd("colorscheme github_dark_high_contrast")

-- detect tabs/spaces indent style
require("guess-indent").setup()

-- show indentation lines
vim.opt.list = true
require("ibl").setup()

-- bottom status bar
require("lualine").setup({
    options = {
        -- alacritty doesn't support ligatures
        icons_enabled = false
    },
    sections = {
        lualine_c = {"filename", "lsp_progress"},
        -- "hostname" instead of default that shows "unix"
        lualine_x = {"hostname", "encoding", "filetype"}
    }
})

-- render errors
local lsp_lines = require("lsp_lines")
lsp_lines.setup({})
vim.diagnostic.config({virtual_text = false})
vim.keymap.set("n", "<C-d>", lsp_lines.toggle)
lsp_lines.toggle() -- disable by default

-- git status in gutter
require("gitsigns").setup({
    numhl = true,
    current_line_blame = true,
    current_line_blame_opts = {delay = 2000}
})

-- file explorer
require("nvim-tree").setup({
    renderer = {
        icons = {show = {file = false, folder = false, folder_arrow = false}}
    }
})

-- set LSP floating window styles
vim.api.nvim_set_hl(0, "NormalFloat", {bg = "#0e1116", fg = "#FFFFFF"})
vim.api.nvim_set_hl(0, "FloatBorder", {bg = "None", fg = "#FFFFFF"})
vim.api.nvim_set_hl(0, "LspInfoBorder", {link = "FloatBorder"})
vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, {border = "single"})

-- LSP bindings
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        local opts = {buffer = ev.buf}
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<space>f",
                       function() vim.lsp.buf.format({async = true}) end, opts)
    end
})

-- LSP autocompletion
local luasnip = require("luasnip")
local cmp = require("cmp")
cmp.setup({
    snippet = {expand = function(args) luasnip.lsp_expand(args.body) end},
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered()
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
        })
    }),
    sources = cmp.config.sources({{name = "nvim_lsp"}}, {{name = "buffer"}})
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- language server setup
local lsp = require("lspconfig")
lsp.nil_ls.setup({capabilities = capabilities})
lsp.rust_analyzer.setup({capabilities = capabilities})
lsp.gopls.setup({capabilities = capabilities})
lsp.pyright.setup({capabilities = capabilities})
lsp.hls.setup({
    filetypes = {"haskell", "lhaskell", "cabal"},
    capabilities = capabilities
})
