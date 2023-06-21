{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    alacritty
    firefox
    gnome-text-editor
    gnome.dconf-editor
    gnome.gnome-disk-utility
    gnome.nautilus
    gnomeExtensions.gtile
    google-chrome
    # monero-gui
    mpv
    obsidian
    # signal-desktop
    # tor-browser-bundle-bin
    vscode
  ];

  fonts.fonts = with pkgs; [
    inter
    jetbrains-mono
    noto-fonts-emoji
  ];

  services = {
    gnome.core-utilities.enable = false;
    xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      displayManager = {
        gdm.enable = true;
        sessionCommands = ''
          dconf load / << EOF
            ${builtins.readFile ./dconf.ini}
          EOF
        '';
      };
    };
  };
}
