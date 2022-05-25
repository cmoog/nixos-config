{ config, pkgs, ... }:

{
  home = {
    username = "charlie";
    homeDirectory = "/home/charlie";
  };

  xdg.configFile = {
    # this should be in gui.nix, but alacritty only looks for config paths under ~/...
    "alacritty/alacritty.yml".text = builtins.readFile ./desktop/alacritty.yml;
    "git/config".text = builtins.readFile ./server/.gitconfig;
    "lazygit/config.yml".text = builtins.readFile ./server/lazygit_config.yml;
  };

  programs = {
    home-manager.enable = true;
    fish = {
      enable = true;
      interactiveShellInit = builtins.readFile ./server/config.fish;
      shellInit = builtins.readFile ./server/config.fish;
      functions = {
        fish_prompt = builtins.readFile ./server/fish_prompt.fish;
        gui = "exec sway";
      };
    };

    neovim = {
      enable = true;
      vimAlias = true;
      package = pkgs.neovim-nightly;
      extraConfig = builtins.readFile ./server/init.vim;
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
        (nvim-treesitter.withPlugins (plugins: [ ]))
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
    jq
    kubectl
    lazydocker
    lazygit
    nixpkgs-fmt
    pandoc
    ripgrep
    rnix-lsp
    sd
    tectonic
    texlab
    unstable.cue
    unstable.git
    unstable.go_1_18
    unstable.ipfs
    unzip
    youtube-dl
    zoxide
  ];

  home.stateVersion = "21.05";
}
