{ pkgs, lib, config, ... }:

let
  cfg = config.gui;
in
with lib; {
  options.gui = {
    enable = mkEnableOption "Enable a user GUI.";
    variant = mkOption {
      type = types.enum [ "sway" ]; # TODO: add gnome config
      default = "sway";
    };
  };
  config = mkIf cfg.enable {
    environment.etc = {
      "sway/config".source = ./sway.config;
    };

    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "bashbar" (builtins.readFile ./swaybar.sh))
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

    # daemon and CLI for wifi
    networking.wireless.iwd.enable = cfg.variant == "sway";

    programs = {
      sway = mkIf (cfg.variant == "sway") {
        enable = true;
        extraPackages = with pkgs; [
          dmenu-wayland
          grim
          sway-contrib.grimshot
          swaybg
          swayidle
          swaylock
          wdisplays
        ];
      };
      wireshark.enable = true;
    };

    services.xserver = {
      enable = true;
      displayManager.startx.enable = true;
    };
  };
}
