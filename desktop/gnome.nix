{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnome-connections
    gnome-text-editor
    gnome.dconf-editor
    gnomeExtensions.gtile
  ];
  programs = { };

  services.gnome.core-utilities.enable = false;
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager = {
      gdm = {
        enable = true;
        autoSuspend = false;
        wayland = false;
      };
    };
  };

  services.xserver.displayManager.sessionCommands = ''
    dconf load / << EOF
      ${builtins.readFile ./dconf.ini}
    EOF
  '';
}
