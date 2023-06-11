{ config, pkgs, ... }:
let
  user = "charlie";
  github-nvim-theme = pkgs.vimUtils.buildVimPlugin {
    name = "github-nvim-theme";
    buildInputs = with pkgs; [ git ];
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
  home = {
    username = user;
    homeDirectory = "/home/${user}";
  };

  programs = {
    home-manager.enable = true;
    fish = {
      enable = true;
      shellInit = builtins.readFile ./server/config.fish;
      shellAliases = {
        copy = "${pkgs.xsel}/bin/xsel --clipboard --input";
        paste = "${pkgs.xsel}/bin/xsel --clipboard --output";
      };
      functions = {
        fish_prompt = builtins.readFile ./server/fish_prompt.fish;
      };
    };

    alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
        working_directory = "./Code";
        window = {
          dimensions = {
            columns = 115;
            lines = 35;
          };
          dynamic_padding = true;
        };
        font = {
          size = 14;
          offset = {
            x = 0;
            y = 2;
          };
          glyph_offset = {
            x = 0;
            y = 1;
          };
        };
        selection = {
          semantic_escape_chars = ",│`|:\"' ()[]{}<>\t";
          save_to_clipboard = true;
        };
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
        github-nvim-theme
        fzf-vim
        lsp-colors-nvim
        nerdtree
        nvim-autopairs
        nvim-lspconfig
        toggleterm-nvim
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
    btop
    deno
    dolt
    duf
    fd
    gh
    go
    gopls
    hledger
    ipfs
    jq
    kubectl
    lazydocker
    monero-cli
    neofetch
    nixpkgs-fmt
    nodePackages.wrangler
    openai-whisper
    pandoc
    ripgrep
    rnix-lsp
    sage
    sd
    sqlite
    typst
    unzip
    youtube-dl
    zig
    (python3.withPackages (pythonPackages: with pythonPackages; [
      ipykernel
      matplotlib
      numpy
      pandas
      plotly
      pytorch
    ]))
  ];

  home.stateVersion = "21.05";
}
