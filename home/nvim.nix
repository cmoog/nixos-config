{ pkgs, ... }:
let
  github-nvim-theme = pkgs.vimUtils.buildVimPlugin {
    name = "github-nvim-theme";
    buildPhase = "rm Makefile";
    src = pkgs.fetchFromGitHub {
      owner = "projekt0n";
      repo = "github-nvim-theme";
      rev = "7b97aa55ef9dabce479f74f86b8c61c1464c9d2e";
      hash = "sha256-DQH+U2jMi80jZYNdnjdXoeYwJY7y1WtpS/w+DMIN6FY=";
    };
  };
in
{
  home.packages = with pkgs.unstable; [
    # haskell-language-server # ~5 GB
    gopls
    lua-language-server
    nixd
    pyright
    rust-analyzer
    shellcheck
    typst-lsp
  ];
  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
    vimAlias = true;
    extraLuaConfig = builtins.readFile ./vim.lua;
    plugins = with pkgs.vimPlugins; [
      github-nvim-theme
      haskell-tools-nvim
      lsp-colors-nvim
      lsp_lines-nvim
      lualine-lsp-progress # adds lsp loading indicator to status bar
      lualine-nvim
      nvim-autopairs
      nvim-lint
      nvim-lspconfig
      nvim-osc52
      nvim-treesitter.withAllGrammars
      pkgs.unstable.vimPlugins.gitsigns-nvim
      plenary-nvim # common dep
      telescope-nvim
      toggleterm-nvim

      # completion engine
      cmp-buffer
      cmp-nvim-lsp
      luasnip
      nvim-cmp
      typescript-tools-nvim
    ];
  };
}
