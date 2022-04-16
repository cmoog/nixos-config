{ config, pkgs, ... }:

{
  home = {
    username = "charlie";
    homeDirectory = "/home/charlie";
  };

  nixpkgs.config.allowUnfree = true;

  xdg.configFile = {
    "alacritty/alacritty.yml".text = builtins.readFile ../alacritty.yml;
    "git/config".text = builtins.readFile ../.gitconfig;
    "lazygit/config.yml".text = builtins.readFile ../lazygit_config.yml;
  };

  programs = {
    home-manager.enable = true;
    fish = {
      enable = true;
      interactiveShellInit = builtins.readFile ../config.fish;
      shellInit = builtins.readFile ../config.fish;
      functions = {
        fish_prompt = builtins.readFile ../fish_prompt.fish;
      };
    };

    neovim = {
      enable = true;
      vimAlias = true;
      package = pkgs.neovim-nightly;
      extraConfig = builtins.readFile ../init.vim;
      plugins = with pkgs.vimPlugins; [
        fzf-vim
        gruvbox
        lsp-colors-nvim
        nerdtree
        nvim-autopairs
        nvim-lspconfig
        toggleterm-nvim
        vim-airline
        vim-gitgutter
        (nvim-treesitter.withPlugins
          (plugins: pkgs.tree-sitter.allGrammars))
      ];
    };

    direnv.enable = true;
    bat.enable = true;
    fzf.enable = true;
  };

  home.packages = with pkgs; [
    aws
    bottom
    delta
    dolt
    duf
    exa
    fd
    gcc
    gh
    google-cloud-sdk
    gopls
    jetbrains-mono
    jq
    kubectl
    lazydocker
    lazygit
    nixpkgs-fmt
    pandoc
    ripgrep
    rnix-lsp
    sd
    texlab
    unstable.cue
    unstable.git
    unstable.go_1_18
    unstable.ipfs
    unzip
    youtube-dl
    zoxide

    gnome.gnome-tweaks
    open-sans
  ];

  home.stateVersion = "21.11";
}
