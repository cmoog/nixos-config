{ config, pkgs, ... }:
{
  home = {
    username = "charlie";
    homeDirectory = "/home/charlie";
  };

  xdg.configFile = {
    # this should be in gui.nix, but alacritty only looks for config paths under ~/...
    "alacritty/alacritty.yml".source = ./desktop/alacritty.yml;
  };

  programs = {
    home-manager.enable = true;
    fish = {
      enable = true;
      shellInit = builtins.readFile ./server/config.fish;
      functions = {
        fish_prompt = builtins.readFile ./server/fish_prompt.fish;
      };
    };

    git = {
      enable = true;
      lfs.enable = true;
      delta = {
        enable = true;
        options = {
          line-numbers = true;
          navigate = true;
        };
      };
      userName = "Charlie Moog";
      userEmail = "moogcharlie@gmail.com";
      extraConfig = {
        # stored in secure enclave on macbook-air with auth required
        user.signingKey = "key::ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGxStcvVFF2s/4GFuLj8ehTzzD1B8Ct9Ntds1G1WONyEUShl8oHoZiByjObeX2wyfJx3ZpzhJ/A7Wa73bTL85Yk= ecdsa-sha2-nistp256";
        gpg.format = "ssh";
        commit.gpgsign = true;
        tag.gpgsign = true;
        diff.colorMoved = "default";
      };
      ignores = [ "result" "/.vscode" "/.direnv" ];
      aliases = {
        ca = "commit --amend --verbose";
        a = "add --all";
        c = "commit --verbose";
        cb = "checkout -b";
        f = "! git commit --fixup $(git log --pretty='%H' -1 --invert-grep --grep 'fixup! ')";
        rb = "rebase --autostash --autosquash --interactive";
        d = "diff";
        pushf = "push --force-with-lease";
        s = "status";
        last = "log -1";
        releasenotes = "log --no-merges --pretty=format:\"- %h %s\"";
        m = ''!
          if git rev-parse --verify master >/dev/null 2>/dev/null; \
          then git checkout master; else git checkout main; fi
        '';
        sm = "submodule update --init --recursive";
      };
    };

    neovim = {
      enable = true;
      vimAlias = true;
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
        (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
      ];
    };

    direnv.enable = true;
    bat.enable = true;

    fzf = {
      enable = true;
      enableFishIntegration = true;
      # respects .gitignore
      defaultCommand = "fd --type=f";
      fileWidgetCommand = "fd --type=f";
    };
    exa = {
      enable = true;
      enableAliases = true;
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
    gitui = {
      enable = true;
      keyConfig = ./server/gitui_key_bindings.ron;
    };
    lazygit = {
      enable = true;
      settings = {
        gui.showCommandLog = false;
        git.paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
        customCommands = [{
          key = "f";
          command = "git f";
          subprocess = true;
          loadingText = "applying fixup...";
          description = "fixup previous commit";
          context = "files";
        }];
      };
    };
  };

  home.packages = with pkgs; [
    awscli2
    bottom
    dolt
    duf
    fd
    gh
    gopls
    jq
    kubectl
    lazydocker
    monero-cli
    nixpkgs-fmt
    nodePackages.wrangler
    pandoc
    ripgrep
    rnix-lsp
    sd
    tectonic
    texlab
    unstable.deno
    unstable.go
    unstable.ipfs
    unstable.vscode
    unzip
    youtube-dl
  ];

  home.stateVersion = "21.05";
}
