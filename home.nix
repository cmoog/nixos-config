{ config, pkgs, ... }:
{
  home = {
    username = "charlie";
    homeDirectory = "/home/charlie";
    sessionPath = [
      "$HOME/bin"
      "$HOME/go/bin"
      "$HOME/.cargo/bin"
      "$HOME/.deno/bin"
    ];
    sessionVariables = {
      EDITOR = "vim";
      GOPATH = "$HOME/go";
      GO111MODULE = "on";
    };
    shellAliases = {
      copy = "${pkgs.xsel}/bin/xsel --clipboard --input";
      paste = "${pkgs.xsel}/bin/xsel --clipboard --output";
      ip = "ip --color=auto";
      g = "git";
      lg = "lazygit";
      ld = "lazydocker";
      rp = "realpath";
      bg = "batgrep";
    };
  };

  programs = {
    home-manager.enable = true;
    fish = {
      enable = true;
      shellInit = ''
        set fish_greeting ""
      '';
      functions = {
        fish_prompt = builtins.readFile ./server/fish_prompt.fish;
        groot = ''
          set --local gitroot (${pkgs.git}/bin/git rev-parse --show-toplevel)
          if [ "$gitroot" = "" ]
            return -1
          end
          cd "$gitroot"
        '';
        pr = ''
          ${pkgs.gh}/bin/gh pr create --fill
          ${pkgs.gh}/bin/gh pr view --web
        '';
        fork = ''
          set --local t $(date -d "now" +"%Y-m-%d-%H-%M-%S")
          nohup $argv > $t.out 2> $t.err < /dev/null &
        '';
        nixdeps = "nix derivation show $argv[1] -r | jq \".[].outputs.out.path\" -r";
        nixshow =
          let
            shallowStringer = ''
              let
                ident = a: a;
                funcs = {
                  "set" = builtins.attrNames;
                  "list" = builtins.typeOf;
                  "lambda" = builtins.typeOf;
                  "path" = builtins.typeOf;
                  "int" = ident;
                  "null" = ident;
                  "float" = ident;
                  "bool" = ident;
                  "string" = ident;
                };
              in a: (funcs.''${builtins.typeOf a} a)
            '';
          in
          ''
            nix eval $argv[1] --apply '${builtins.replaceStrings ["\n"] [" "] shallowStringer}' \
              --json | ${pkgs.jq}/bin/jq
          '';
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

    neovim =
      let
        github-nvim-theme = pkgs.vimUtils.buildVimPlugin {
          name = "github-nvim-theme";
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
        enable = true;
        vimAlias = true;
        extraConfig = builtins.readFile ./server/init.vim;
        plugins = with pkgs.vimPlugins; [
          fzf-vim
          github-nvim-theme
          gitsigns-nvim
          lsp-colors-nvim
          lualine-nvim
          nvim-autopairs
          nvim-lspconfig
          nvim-tree-lua
          nvim-treesitter.withAllGrammars
          toggleterm-nvim
        ];
      };

    direnv.enable = true;
    bat = {
      enable = true;
      config = {
        style = "plain";
      };
      extraPackages = with pkgs.bat-extras; [ batman batgrep ];
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
      # respects .gitignore
      defaultCommand = "fd --type=f";
      fileWidgetCommand = "fd --type=f";
      fileWidgetOptions = [
        "--preview 'bat -n --color=always {}'"
        "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
      ];
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
        git.autoFetch = false;
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
    broot
    btop
    deno
    dolt
    duf
    fd
    gh
    go
    gopls
    hledger
    hyperfine
    jq
    lazydocker
    neofetch
    nil
    nixpkgs-fmt
    nodePackages.wrangler
    procs
    ripgrep
    sage
    sd
    sqlite
    tio
    tokei
    typst
    unzip
    usbutils
    youtube-dl
    zig
    (python3.withPackages (pyPkgs: with pyPkgs; [
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
