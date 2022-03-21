{ config, pkgs, ... }:

{
  home.username = "charlie";
  home.homeDirectory = "/home/charlie";

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  xdg.configFile."alacritty/alacritty.yml".text = builtins.readFile ../alacritty.yml;
  xdg.configFile."git/config".text = builtins.readFile ../.gitconfig;
  xdg.configFile."lazygit/config.yml".text = builtins.readFile ../lazygit_config.yml;

  programs.fish = {
    enable = true;
    interactiveShellInit = builtins.readFile ../config.fish;
    shellInit = builtins.readFile ../config.fish;
    functions = {
      fish_prompt = builtins.readFile ../fish_prompt.fish;
    };
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = builtins.readFile ../init.vim;
    plugins = with pkgs.vimPlugins; [
      fzf-vim
      gruvbox
      lsp-colors-nvim
      nerdtree
      nvim-autopairs
      nvim-lspconfig
      vim-airline
      vim-gitgutter
      (nvim-treesitter.withPlugins
        (plugins: pkgs.unstable.tree-sitter.allGrammars))
    ];
  };

  programs.direnv.enable = true;
  programs.bat.enable = true;
  programs.fzf.enable = true;

  home.packages = with pkgs; [
    aws
    bottom
    unstable.cue
    delta
    dolt
    exa
    fd
    gcc
    gh
    unstable.go_1_18
    google-cloud-sdk
    gopls
    unstable.ipfs
    jetbrains-mono
    jq
    kubectl
    lazydocker
    lazygit
    nixpkgs-fmt
    pandoc
    ripgrep
    rnix-lsp
    unzip
    youtube-dl
    zoxide
  ];

  # don't change
  home.stateVersion = "21.05";
}
