{ pkgs, lib, config, ... }:

let
  cfg = config.moog.gui;
in
with lib; {
  options.moog.gui = {
    enable = mkEnableOption "Enable a user GUI.";
    variant = mkOption {
      type = types.enum [ "sway" "gnome" ];
      default = "sway";
    };
  };
  config = mkIf cfg.enable (mkMerge [
    {
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

      fonts.packages = with pkgs; [
        inter
        jetbrains-mono
        noto-fonts-emoji
      ];
      programs = {
        wireshark.enable = true;
      };
    }
    (mkIf (cfg.variant == "gnome") {
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
      environment.systemPackages = with pkgs; [
        (writeShellScriptBin "bashbar" (builtins.readFile ./swaybar.sh))
      ];

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
    })
  ]);
}
