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
      auto-pairs
      fzf-vim
      gruvbox
      lsp-colors-nvim
      nerdtree
      nvim-lspconfig
      nvim-treesitter
      rust-vim
      vim-airline
      vim-airline-themes
      vim-fish
      vim-gitgutter
      vim-go
      vim-nix
      vim-toml
    ];
  };

  programs.bat.enable = true;
  programs.fzf.enable = true;
  home.packages = with pkgs; [
    aws
    bottom
    cue
    delta
    dolt
    exa
    fd
    gcc
    gh
    go_1_17
    google-cloud-sdk
    gopls
    ipfs
    jetbrains-mono
    jq
    kubectl
    lazydocker
    lazygit
    nixpkgs-fmt
    pandoc
    ripgrep
    rnix-lsp
    rust-analyzer
    unzip
    wasmtime
    youtube-dl
    zoxide
  ];

  # don't change
  home.stateVersion = "21.05";
}
