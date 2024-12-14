{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dhall-lsp-server
    gopls
    nixd
    nodePackages.bash-language-server
    nodePackages.typescript-language-server
    shellcheck
    typstfmt
    typst-lsp
  ];
  programs.helix = {
    enable = true;
    languages = {
      language = [
        {
          name = "nix";
          formatter.command = "nixfmt";
          language-servers = [ "nixd" ];
        }
        {
          name = "futhark";
          scope = "source.futhark";
          language-servers = [ "futhark" ];
          comment-tokens = "--";
          file-types = [ "fut" ];
        }
        {
          name = "typst";
          formatter.command = "typstfmt";
        }
      ];
      language-server = {
        haskell-language-server.config.haskell = {
          formattingProvider = "fourmolu";
          plugin.fourmolu.config.external = true;
        };
        nixd.command = "nixd";
        futhark = {
          command = "futhark";
          args = [ "lsp" ];
        };
      };
    };
    settings = {
      theme = {
        dark = "gruvbox_dark_hard";
        light = "flexoki_light";
      };
      editor = {
        auto-format = false;
        auto-save = true;
        bufferline = "always";
        color-modes = true;
        completion-replace = true;
        completion-timeout = 100;
        completion-trigger-len = 1;
        cursorline = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker.hidden = false;
        indent-guides = {
          render = true;
          skip-levels = 1;
          character = "┊";
        };
        inline-diagnostics.cursor-line = "warning";
        end-of-line-diagnostics = "hint";
        line-number = "relative";
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
        popup-border = "all";
        shell = [
          "fish"
          "-c"
        ];
        statusline.center = [ "workspace-diagnostics" ];
        statusline.right = [
          "version-control"
          "spacer"
          "diagnostics"
          "position"
          "position-percentage"
        ];
        true-color = true;
      };
      keys.insert = {
        C-t = [
          ":new"
          "file_picker"
        ];
        j.k = "normal_mode";
        j.j = "normal_mode";
      };
      keys.normal = {
        K = "hover";
        space = {
          p = "file_picker";
          f = ":format";
          q = [
            ":write-all"
            ":quit-all"
          ];
          k = "expand_selection";
          m = "shrink_selection";
        };
        C-h = "goto_previous_buffer";
        C-l = "goto_next_buffer";
        C-t = [
          ":new"
          "file_picker"
        ];
        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ];
        "}" = "goto_next_paragraph";
        "{" = "goto_prev_paragraph";
      };
    };
    themes = {
      gruvbox_moog = {
        inherits = "gruvbox_dark_hard";
        "variable.builtin".modifiers = [ ];
        "variable.parameter".modifiers = [ ];
        "type.enum.variant".modifiers = [ ];
        "attribute".modifiers = [ ];
      };
      ghdark_moog = {
        inherits = "github_dark_high_contrast";
        comment = {
          modifiers = [ "dim" ];
        };
      };
    };
  };
}
