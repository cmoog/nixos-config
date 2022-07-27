{ config, pkgs, ... }:
let
  toggleterm = pkgs.vimUtils.buildVimPlugin {
    name = "toggleterm.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "akinsho";
      repo = "toggleterm.nvim";
      rev = "cd12ed737d3de2757a540ddf4962a6de05881127";
      sha256 = "p/ZwqfGIOAWEHpC56jSU/MnNIpNDW4PpYBkr5Os8XQw=";
    };
  };
in
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

  home.file = {
    ".gitignore".text = ''
      /.vscode
      /.direnv
    '';
  };

  programs = {
    home-manager.enable = true;
    fish = {
      enable = true;
      interactiveShellInit = builtins.readFile ./server/config.fish;
      shellInit = builtins.readFile ./server/config.fish;
      functions = {
        fish_prompt = builtins.readFile ./server/fish_prompt.fish;
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

        # use the nixpkgs version once they update to remove
        # the use of a deprecated neovim api
        # toggleterm-nvim
        toggleterm

        vim-airline
        vim-gitgutter
        (nvim-treesitter.withPlugins (plugins: [ ]))
      ];
    };

    direnv.enable = true;
    bat.enable = true;
    fzf.enable = true;
    exa = {
      enable = true;
      enableAliases = true;
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  home.packages = with pkgs; [
    aws
    bottom
    delta
    dolt
    duf
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
    unstable.go_1_18
    unstable.ipfs
    unzip
    youtube-dl
  ];

  home.stateVersion = "21.05";
}
