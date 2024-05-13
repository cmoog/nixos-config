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
      ip = "ip --color=auto";
      g = "git";
      lg = "lazygit";
      rp = "realpath";
      bg = "batgrep";
      clear = "clear -x";
      stui = "systemctl-tui";
      v = "vim";
      pr = "gh pr create --draft --fill";
      prs = "gh search prs --state=open --involves=@me --updated=2024";
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
        fish_prompt = builtins.readFile ./fish_prompt.fish;
        gr = ''
          set --local gitroot (${pkgs.git}/bin/git rev-parse --show-toplevel)
          if [ "$gitroot" = "" ]
            return -1
          end
          cd "$gitroot"
        '';
        fork = ''
          set --local t $(date -d "now" +"%Y-m-%d-%H-%M-%S")
          nohup $argv > $t.out 2> $t.err < /dev/null &
        '';
        nixdeps = "nix derivation show $argv[1] -r | jq \".[].outputs.out.path\" -r";
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
      ignores = [ "result" "/.vscode" ".direnv" ".envrc" ];
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
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    bat = {
      enable = true;
      config.style = "plain";
      extraPackages = with pkgs.bat-extras; [ batman batgrep ];
    };
    btop = {
      enable = true;
      settings = {
        color_theme = "matcha-dark-sea";
        rounded_corners = false;
        vim_keys = true;
      };
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
      package = pkgs.unstable.lazygit;
      settings = {
        git.autoFetch = false;
        git.paging.colorArg = "always";
        gui.showCommandLog = false;
        notARepository = "quit";
        os.editPreset = "nvim-remote";
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
    deno
    duf
    fd
    gh
    go
    jq
    neofetch
    nix-output-monitor
    nix-tree
    nixpkgs-fmt
    parted
    procs
    pv
    ripgrep
    # sage # 4.7 GB, consider default not including
    sd
    sqlite
    systemctl-tui
    tio
    tokei
    typst
    unzip
    usbutils
    zellij
    (python3.withPackages (p: with p; [
      ipykernel
      matplotlib
      numpy
      pandas
      # pytorch
    ]))
    (pkgs.writeShellScriptBin "copy" ''
      DATA=$(</dev/stdin)
      printf "\033]52;c;$(printf %s "$DATA" | base64 | tr -d '\n\r')\a"
    '')
  ];

  home.stateVersion = "21.05";
}
