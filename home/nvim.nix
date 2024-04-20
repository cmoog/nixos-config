{ pkgs, ... }:
let
  github-nvim-theme = pkgs.vimUtils.buildVimPlugin {
    name = "github-nvim-theme";
    buildPhase = "rm Makefile";
    src = pkgs.fetchFromGitHub {
      owner = "projekt0n";
      repo = "github-nvim-theme";
      rev = "ab90dd7bd835cb90572e2d8337ff50452cdec58c";
      hash = "sha256-6ODsunlGNNi0vlgIDpol4tDBOl1MZVsW9QoI3tHquO8=";
    };
  };
in
{
  home.packages = with pkgs.unstable; [
    dhall-lsp-server
    gopls
    haskell-language-server
    hyperfine
    nil
    pyright
    rust-analyzer
    typst-lsp
  ];
  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = builtins.readFile ./init.vim;
    extraLuaConfig = builtins.readFile ./vim.lua;
    plugins = with pkgs.vimPlugins; [
      indent-blankline-nvim
      lsp-colors-nvim
      nvim-lspconfig

      typescript-tools-nvim
      plenary-nvim # required by typescript-tools

      # autocomplete
      cmp-buffer
      cmp-nvim-lsp
      luasnip
      nvim-cmp
      {
        type = "lua";
        plugin = fzf-lua;
        config = ''
          local fzf = require("fzf-lua")
          vim.keymap.set("n", "<C-p>", fzf.files)
          vim.keymap.set("n", "<C-r>", fzf.git_status)
          vim.keymap.set("n", "<C-f>", fzf.live_grep)
        '';
      }
      {
        type = "lua";
        plugin = toggleterm-nvim;
        config = ''
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
        '';
      }
      {
        type = "lua";
        plugin = nvim-autopairs;
        config = "require('nvim-autopairs').setup()";
      }
      {
        # highlight with treesitter semantics
        type = "lua";
        plugin = nvim-treesitter.withAllGrammars;
        config = ''
          require("nvim-treesitter.configs").setup({
              highlight = {enable = true},
              indent = {enable = true}
          })
        '';
      }
      {
        type = "lua";
        plugin = github-nvim-theme;
        config = ''
          require("github-theme").setup({
              options = {
                  styles = {
                      -- disable italic keywords
                      keywords = "NONE"
                  }
              }
          })
          vim.cmd("colorscheme github_dark_high_contrast")

          -- show indentation lines
          vim.opt.list = true
          require("ibl").setup()
        '';
      }
      {
        type = "lua";
        plugin = guess-indent-nvim;
        config = "require('guess-indent').setup()";
      }
      # adds lsp loading indicator to status bar
      lualine-lsp-progress
      {
        # bottom status bar
        type = "lua";
        plugin = lualine-nvim;
        config = ''
          require("lualine").setup({
              options = {
                  icons_enabled = true
              },
              sections = {
                  lualine_c = {"filename", "lsp_progress"},
                  -- "hostname" instead of default that shows "unix"
                  lualine_x = {"hostname", "encoding", "filetype"}
              }
          })
        '';
      }
      {
        type = "lua";
        plugin = lsp_lines-nvim;
        config = ''
          local lsp_lines = require("lsp_lines")
          lsp_lines.setup({})
          vim.diagnostic.config({virtual_text = false})
          vim.keymap.set("n", "<C-d>", lsp_lines.toggle)
          lsp_lines.toggle() -- disable by default
        '';
      }
      {
        type = "lua";
        plugin = gitsigns-nvim;
        config = ''
          require("gitsigns").setup({
               numhl = true,
               current_line_blame = true,
               current_line_blame_opts = {delay = 2000}
           })
        '';
      }
      {
        type = "lua";
        plugin = nvim-tree-lua;
        config = ''
          vim.api.nvim_set_keymap("n", "<C-b>", "<cmd>:NvimTreeToggle<CR>",
                        {noremap = true, silent = true})
          require("nvim-tree").setup({
              renderer = {
                  icons = {show = {file = false, folder = false, folder_arrow = false}}
              },
              update_focused_file = {enable = true},
          })
        '';
      }
    ];
  };
}
