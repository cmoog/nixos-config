{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  stylix = {
    image = "${pkgs.gnome.gnome-backgrounds}/share/backgrounds/gnome/blobs-l.svg";
    base16Scheme = ./theme.yaml;
    fonts = {
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
      serif = config.stylix.fonts.sansSerif;
      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    alacritty
    electrum
    firefox
    gnome-connections
    gnome-text-editor
    gnome.dconf-editor
    gnome.gnome-disk-utility
    gnome.nautilus
    gnomeExtensions.gtile
    google-chrome
    monero-gui
    mpv
    obsidian
    signal-desktop
    unstable.sniffnet
    unstable.tor-browser-bundle-bin
    vscode
  ];

  fonts.fonts = with pkgs; [
    font-awesome
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
        gdm = {
          enable = true;
          autoSuspend = false;
          wayland = false;
        };
        sessionCommands = ''
          dconf load / << EOF
            ${builtins.readFile ./dconf.ini}
          EOF
        '';
      };
    };
  };
}
