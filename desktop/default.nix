{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.etc = {
    "sway/config".source = ./sway.config;
  };

  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "bashbar" (builtins.readFile ./swaybar.sh))
    alacritty
    firefox
    gnome.gnome-disk-utility
    gnome.nautilus
    mpv
    obsidian
    pulsemixer
    vscode
  ];

  fonts.fonts = with pkgs; [
    inter
    jetbrains-mono
    noto-fonts-emoji
  ];

  # daemon and CLI for wifi
  networking.wireless.iwd.enable = true;

  sound.enable = true;

  programs = {
    sway = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu-wayland
        grim
        sway-contrib.grimshot
        swaybg
        swayidle
        swaylock
      ];
    };
  };

  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
  };
}
