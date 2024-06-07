{ pkgs, lib, ... }:
{
  imports = [
    ./helix.nix
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
      EDITOR = "hx";
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
      };
    };
    eza = {
      enable = true;
      enableFishIntegration = true;
    };
    git = {
      enable = true;
      lfs.enable = true;
      userName = "Charlie Moog";
      userEmail = "moogcharlie@gmail.com";
      extraConfig = {
        diff.colorMoved = "default";
        init.defaultBranch = "master";
        rerere.enabled = true;
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
      settings = {
        git.autoFetch = false;
        git.paging.colorArg = "always";
        gui.showCommandLog = false;
        notARepository = "quit";
        os = rec {
          edit = lib.strings.concatStringsSep " && " [
            "zellij action toggle-floating-panes"
            "zellij action write 27"
            "zellij action write-chars ':o {{filename}}'"
            "zellij action write 13"
            "zellij action toggle-floating-panes"
            "zellij action close-pane"
          ];
          editAtLine = edit;
          editInTerminal = false;
        };
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
    zellij = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        default_layout = "compact";
        default_mode = "locked";
        keybinds.unbind = "Ctrl g";
        pane_frames = false;
        plugins = [ "compact-bar" ];
        simplified_ui = true;
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
    nix-output-monitor
    nix-tree
    nixpkgs-fmt
    parted
    procs
    pv
    ripgrep
    sd
    socat
    sqlite
    systemctl-tui
    tio
    tokei
    typst
    unzip
    (writeShellScriptBin "copy" ''
      DATA=$(</dev/stdin)
      printf "\033]52;c;$(printf %s "$DATA" | base64 | tr -d '\n\r')\a"
    '')
  ];

  home.stateVersion = "21.05";
}
