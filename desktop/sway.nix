{ config, pkgs, ... }:

{
  environment.etc = {
    "sway/config".source = ./sway.config;
    "xdg/waybar/config".source = ./waybar.config;
    "xdg/waybar/style.css".source = ./waybar.css;
  };

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    blueman
    networkmanagerapplet
    pavucontrol
  ];

  hardware = {
    pulseaudio.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
  sound.enable = true;

  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        dmenu-wayland
        grim
        sway-contrib.grimshot
        waybar
      ];
      extraSessionCommands = ''
        eval $(ssh-agent)
        export SSH_AUTH_SOCK
      '';
    };
  };

  services = {
    blueman.enable = true;
    xserver = {
      enable = true;
      displayManager.startx.enable = true;
    };
  };
}
