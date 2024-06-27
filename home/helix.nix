{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gopls
    nixd
    nodePackages.bash-language-server
    nodePackages.typescript-language-server
    shellcheck
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
      ];
      language-server = {
        haskell-language-server.config.haskell = {
          formattingProvider = "fourmolu";
          plugin.fourmolu.config.external = true;
        };
        nixd.command = "nixd";
      };
    };
    settings = {
      theme = "gruvbox_moog";
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
          "selections"
          "register"
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
      keys.select = {
        d = [
          "yank_to_clipboard"
          "delete_selection"
        ];
        y = "yank_to_clipboard";
      };
      keys.normal = {
        space = {
          f = ":fmt";
          p = "file_picker";
          w = ":write-all";
          q = ":quit-all";
          k = "expand_selection";
          m = "shrink_selection";
        };
        C-h = "goto_previous_buffer";
        C-l = "goto_next_buffer";
        C-t = [
          ":new"
          "file_picker"
        ];
        C-g = [
          ":new"
          ":insert-output lazygit"
          ":redraw"
          ":buffer-close!"
          ":redraw"
        ];
        D = [
          "extend_to_line_end"
          "yank_to_clipboard"
          "delete_selection"
        ];
        d = [
          "yank_to_clipboard"
          "delete_selection"
        ];
        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ];
        "}" = "goto_next_paragraph";
        "{" = "goto_prev_paragraph";
        K = "hover";
        p = "paste_clipboard_after";
        X = "extend_line_above";
        y = "yank_to_clipboard";
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
