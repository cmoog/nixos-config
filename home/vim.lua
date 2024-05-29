local o = vim.opt
o.autoindent = true
o.background = 'dark'
o.backspace = 'indent,eol,start'
o.clipboard = 'unnamed'
o.conceallevel = 0
o.cursorline = true
o.encoding = 'utf-8'
o.expandtab = true
o.fileencoding = 'utf-8'
o.filetype = 'on'
o.formatoptions:append('t')
o.formatoptions:remove('l')
o.linebreak          = true
o.mouse              = 'a'
o.number             = true
o.ruler              = true
o.shiftwidth         = 2
o.so                 = 999 -- prefer to keep cursor in middle of buffer
o.splitbelow         = true
o.splitright         = true
o.syntax             = 'on'
o.tabstop            = 2
o.timeoutlen         = 1000
o.ttimeoutlen        = 0
o.wrap               = true
o.listchars          = { trail = '·', nbsp = '␣', tab = "» " }
o.list               = true -- enable show trailing whitespace
vim.g.mapleader      = ' '  -- spacebar as leader
vim.g.maplocalleader = ' '

vim.keymap.set("i", "jj", "<esc>", { noremap = true })
vim.keymap.set("i", "jk", "<esc>", { noremap = true })

-- tab keybinds
vim.keymap.set("n", "<C-h>", "gT", { noremap = true })
vim.keymap.set("n", "<C-l>", "gt", { noremap = true })
vim.keymap.set("n", "<C-t>", function()
  vim.cmd([[:tabnew]])
  require('telescope.builtin').git_files()
end)

vim.cmd(
  'autocmd BufRead,BufNewFile *.md,*.txt,*.tex,*.cls setlocal textwidth=100 spell spelllang=en_us')
vim.cmd('autocmd BufRead,BufNewFile *.typ setlocal textwidth=100 filetype=typst')
vim.cmd('autocmd FileType tex,gitcommit setlocal spell spelllang=en_us')

-- error color for tailing whitespace
vim.cmd([[match errorMsg /\s\+$/]])

-- border styles
vim.diagnostic.config { float = { border = "rounded" } }
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

require('telescope').setup({
  pickers = {
    live_grep = {
      additional_args = function(_)
        return { "--hidden" }
      end
    }
  }
})

local telescope = require('telescope.builtin')
vim.keymap.set("n", "<leader>d", telescope.diagnostics, { desc = "[d]iagnostics picker" })
vim.keymap.set("n", "<leader>s", telescope.lsp_workspace_symbols, { desc = "[s]ymbols picker" })
vim.keymap.set("n", "<leader>b", telescope.buffers, { desc = "[b]uffers picker" })
vim.keymap.set("n", "gd", telescope.lsp_definitions, { desc = "[g]o to [d]efinition picker" })
vim.keymap.set("n", "gr", telescope.lsp_references, { desc = "[g]o to [r]eferences picker" })
vim.keymap.set("n", "<leader>j", vim.diagnostic.goto_next, { desc = "goto next diagnostic" })
vim.keymap.set("n", "<leader>k", vim.diagnostic.goto_prev, { desc = "goto prev diagnostic" })
vim.keymap.set('n', '<C-p>', telescope.git_files, { desc = "git files picker" })
vim.keymap.set('n', '<C-f>', telescope.live_grep, { desc = "live grep picker" })
vim.keymap.set('n', '<C-r>', telescope.git_status, { desc = "git status picker" })
vim.keymap.set('n', '<leader>l', function() require('gitsigns').nav_hunk('next') end, { desc = "next git hunk" })
vim.keymap.set('n', '<leader>h', function() require('gitsigns').nav_hunk('prev') end, { desc = "prev git hunk" })

vim.keymap.set('n', '<leader>i', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
  { desc = "[i]nlay hints toggle" })

vim.keymap.set('n', '<leader>km', telescope.keymaps, { desc = "[k]ey [m]aps picker" })

-- LSP bindings
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.hover, { desc = "[h]over symbol", buffer = ev.buf })
    vim.keymap.set("n", "rn", vim.lsp.buf.rename, { desc = "[r]e[n]ame symbol", buffer = ev.buf })
    vim.keymap.set("n", "ca", vim.lsp.buf.code_action, { desc = "[c]ode [a]ction", buffer = ev.buf })
    vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end,
      { desc = "[f]ormat buffer", buffer = ev.buf })
  end
})

-- LSP autocompletion
local luasnip = require("luasnip")
local cmp = require("cmp")
cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered()
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    })
  }),
  sources = cmp.config.sources({ { name = "nvim_lsp" } }, { { name = "buffer" } })
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- language server setup
local lsp = require("lspconfig")
lsp.rust_analyzer.setup({ capabilities = capabilities })
lsp.typst_lsp.setup({ capabilities = capabilities })
lsp.gopls.setup({ capabilities = capabilities })
lsp.zls.setup({ capabilities = capabilities })
lsp.nixd.setup({
  capabilities = capabilities,
  cmd = {
    "nixd",
    "--nixos-options-expr",
    [[
    let pkgs = import <nixpkgs> { }; in
    (pkgs.lib.evalModules {
      modules = [
        { nixpkgs.hostPlatform = builtins.currentSystem; }
      ] ++ import <nixpkgs/nixos/modules/module-list.nix>;
    }).options
    ]]
  }
})
lsp.denols.setup({
  capabilities = capabilities,
  root_dir = lsp.util.root_pattern("deno.json", "deno.jsonc"),
})
lsp.pyright.setup({ capabilities = capabilities })
require("haskell-tools")
require("typescript-tools").setup({})

-- special config for using lua to configure nvim
lsp.lua_ls.setup({
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path .. '/.luarc.json') or
        vim.loop.fs_stat(path .. '/.luarc.jsonc') then
      return
    end
    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config
      .settings.Lua, {
        runtime = { version = 'LuaJIT' },
        workspace = {
          checkThirdParty = false,
          library = { vim.env.VIMRUNTIME }
        }
      })
  end,
  settings = { Lua = {} }
})

require("toggleterm").setup({
  size = 15,
  -- bottom terminal
  open_mapping = [[<C-j>]]
})
local Terminal = require("toggleterm.terminal").Terminal

-- floating terminal
local floating = Terminal:new({ direction = "float", hidden = true })
vim.keymap.set("n", "<C-\\>", function() floating:toggle() end)
vim.keymap.set("t", "<C-\\>", function() floating:toggle() end)

-- lazygit floating terminal
local lazygit = Terminal:new({
  cmd = "lazygit",
  direction = "float",
  hidden = true
})
vim.keymap.set("n", "<C-g>", function() lazygit:toggle() end)
vim.keymap.set("t", "<C-g>", function() lazygit:toggle() end)

require('nvim-autopairs').setup()

require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
  indent = { enable = true }
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

require("lualine").setup({
  options = {
    icons_enabled = true
  },
  sections = {
    lualine_c = { "filename", "lsp_progress" },
    -- "hostname" instead of default that shows "unix"
    lualine_x = { "hostname", "encoding", "filetype" }
  }
})

local lsp_lines = require("lsp_lines")
lsp_lines.setup({})
vim.diagnostic.config({ virtual_text = false })
vim.keymap.set("n", "<C-d>", lsp_lines.toggle)
lsp_lines.toggle() -- disable at startup

require("gitsigns").setup({
  numhl = true,
  current_line_blame = true,
  current_line_blame_opts = { delay = 2000 }
})

require('lint').linters_by_ft = {
  sh = { 'shellcheck' },
}
vim.cmd([[autocmd BufWritePost *.sh,*.bash lua require('lint').try_lint()]])

local function copy(lines, _)
  require('osc52').copy(table.concat(lines, '\n'))
end

local function paste()
  return { vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('') }
end

vim.g.clipboard = {
  name = 'osc52',
  copy = { ['+'] = copy, ['*'] = copy },
  paste = { ['+'] = paste, ['*'] = paste },
}
