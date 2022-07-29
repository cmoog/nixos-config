{ config, pkgs, ... }:
# import this into configuration.nix to enable a nixos desktop workflow

{
  # imports = [ ./sway.nix ];
  imports = [ ./gnome.nix ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    alacritty
    electrum
    firefox
    gnome.gnome-disk-utility
    gnome.nautilus
    google-chrome
    monero-gui
    mpv
    signal-desktop
    tor-browser-bundle-bin
    vscode
  ];

  fonts.fonts = with pkgs; [ font-awesome jetbrains-mono san-francisco-font ];

  programs = { };
}
