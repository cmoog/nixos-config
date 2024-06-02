{ pkgs, inputs, ... }:
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
      (pkgs.vimUtils.buildVimPlugin {
        name = "github-nvim-theme";
        src = inputs.github-nvim-theme;
      })
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
