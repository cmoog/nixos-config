{ pkgs, lib, config, ... }:

let
  cfg = config.gui;
in
with lib; {
  options.gui = {
    enable = mkEnableOption "Enable a user GUI.";
    variant = mkOption {
      type = types.enum [ "sway" "gnome" ];
      default = "sway";
    };
  };
  config = mkIf cfg.enable (mkMerge [{
    environment.systemPackages = with pkgs; [
      alacritty
      chromium
      firefox
      gnome.gnome-disk-utility
      gnome.nautilus
      mpv
      tor-browser-bundle-bin
      wireshark
    ];

    fonts.fonts = with pkgs; [
      inter
      jetbrains-mono
      noto-fonts-emoji
    ];
    programs = {
      wireshark.enable = true;
    };
  }
    (mkIf (cfg.variant == "gnome") {
      networking.wireless.enable = true;
      networking.wireless.iwd.enable = false;

      services.gnome.core-utilities.enable = false;
      services.xserver = {
        enable = true;
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
      };
    })
    (mkIf (cfg.variant == "sway") {
      environment.etc = {
        "sway/config".source = ./sway.config;
      };
      environment.systemPackages = [
        (writeShellScriptBin "bashbar" (builtins.readFile ./swaybar.sh))
      ];

      # daemon and CLI for wifi
      networking.wireless.iwd.enable = true;
      networking.wireless.enable = false;

      programs = {
        sway = {
          enable = true;
          extraPackages = with pkgs; [
            dmenu-wayland
            greetd.tuigreet
            grim
            sway-contrib.grimshot
            swaybg
            swayidle
            swaylock
            wdisplays
          ];
        };
      };

      systemd.services.greetd.serviceConfig = {
        # prevents boot logs from conflicting with tuigreet
        TTYReset = true;
        TTYVHangup = true;
        TTYVTDisallocate = true;
      };

      services.greetd = {
        enable = true;
        settings = {
          default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks --cmd sway";
        };
      };
    })]);
}
