{ pkgs, ... }:
{
  imports = [
    ./nvim.nix
  ];
  home = {
    username = "charlie";
    homeDirectory = "/home/charlie";
    sessionPath = [
      "$HOME/bin"
      "$GOPATH/bin"
      "$CARGO_HOME/bin"
      "$HOME/.deno/bin"
    ];
    sessionVariables = rec {
      EDITOR = "vim";
      GO111MODULE = "on";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      GOPATH = "${XDG_DATA_HOME}/go";
      CARGO_HOME = "${XDG_DATA_HOME}/cargo";
    };
    shellAliases = {
      copy = "${pkgs.xsel}/bin/xsel --clipboard --input";
      paste = "${pkgs.xsel}/bin/xsel --clipboard --output";
      ip = "ip --color=auto";
      g = "git";
      lg = "lazygit";
      rp = "realpath";
      bg = "batgrep";
      clear = "clear -x";
    };
  };

  programs = {
    home-manager.enable = true;
    gitui = {
      enable = true;
      keyConfig = builtins.readFile "${pkgs.gitui.src}/vim_style_key_config.ron";
    };
    fish = {
      enable = true;
      shellInit = ''
        set fish_greeting ""
      '';
      functions = {
        fish_prompt = builtins.readFile ./fish_prompt.fish;
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
    eza = {
      enable = true;
      enableAliases = true;
    };

    tmux = {
      enable = true;
      mouse = true;
      terminal = "xterm-256color";
      keyMode = "vi";
      baseIndex = 1;
      extraConfig = ''
        bind-key v split-window -h
        bind-key s split-window -v

        set -g status-bg black
        set -g status-fg white
        set -g status-left-length 0
        set -g status-right-length 0
        set -g status-right ' '

        # Shift arrow to switch windows
        bind -n S-Left  previous-window
        bind -n S-Right next-window
      '';
    };
    git = {
      enable = true;
      lfs.enable = true;
      userName = "Charlie Moog";
      userEmail = "moogcharlie@gmail.com";
      extraConfig = {
        # stored in secure enclave on macbook-air with auth required
        user.signingKey = "key::ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGxStcvVFF2s/4GFuLj8ehTzzD1B8Ct9Ntds1G1WONyEUShl8oHoZiByjObeX2wyfJx3ZpzhJ/A7Wa73bTL85Yk= ecdsa-sha2-nistp256";
        gpg.format = "ssh";
        commit.gpgsign = true;
        tag.gpgsign = true;
        diff.colorMoved = "default";
        init.defaultBranch = "master";
      };
      ignores = [ "result" "/.vscode" "/.direnv" "/.envrc" ];
      aliases = {
        ca = "commit --amend --verbose";
        ce = "commit --allow-empty-message -m ''";
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
      defaultCommand = "fd --type=f --hidden --exclude=.git";
      fileWidgetCommand = "fd --type=f --hidden --exclude=.git";
      fileWidgetOptions = [
        "--preview 'bat -n --color=always {}'"
        "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
      ];
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
        git.paging.colorArg = "always";
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
    atuin = {
      enable = true;
      # keep bash minimal
      enableBashIntegration = false;
      flags = [ "--disable-up-arrow" ];
      settings = {
        auto_sync = false;
        update_check = false;
      };
    };
  };

  home.packages = with pkgs; [
    btop
    deno
    duf
    fd
    gh
    go
    gopls
    hyperfine
    jq
    lazydocker
    neofetch
    nil
    nix-tree
    nixpkgs-fmt
    parted
    procs
    pyright
    ripgrep
    sage # 4.7 GB, consider default not including
    sd
    sqlite
    tio
    tokei
    typst
    typst-lsp
    unzip
    usbutils
    (python3.withPackages (p: with p; [
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
