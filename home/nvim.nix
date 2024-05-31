{ pkgs, ... }:
let
  github-nvim-theme = pkgs.vimUtils.buildVimPlugin {
    name = "github-nvim-theme";
    buildPhase = "rm Makefile";
    src = pkgs.fetchFromGitHub {
      owner = "projekt0n";
      repo = "github-nvim-theme";
      rev = "d832925e77cef27b16011a8dfd8835f49bdcd055";
      hash = "sha256-vsIr3UrnajxixDo0cp+6GoQfmO0KDkPX8jw1e0fPHo4=";
    };
  };
in
{
  home.packages = with pkgs.unstable; [
    gopls
    lua-language-server
    nixd
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
