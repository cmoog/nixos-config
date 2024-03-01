-- new tabs
vim.keymap.set("n", "<C-t>", "<cmd>:tabnew<CR>")

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
        vim.keymap.set("n", "<space>f", function() vim.lsp.buf.format({async = true}) end, opts)
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
lsp.typst_lsp.setup({capabilities = capabilities})
lsp.gopls.setup({capabilities = capabilities})
lsp.zls.setup({capabilities = capabilities})
lsp.pyright.setup({capabilities = capabilities})
lsp.hls.setup({
    capabilities = capabilities,
    filetypes = {"haskell", "lhaskell", "cabal"}
})
require("typescript-tools").setup({})
