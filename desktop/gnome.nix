{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnome-connections
    gnome-text-editor
    gnome.dconf-editor
    gnomeExtensions.gtile
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
