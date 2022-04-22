# NixOS configuration.nix
{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  time.timeZone = "America/Chicago";

  networking = {
    hostName = "charlie-nuc";

    useDHCP = false;
    wireless.enable = false;
    interfaces = {
      enp5s0.useDHCP = true;
      eno1.useDHCP = false;

      eno1.ipv4.addresses = [{
        # static local IP for connecting directly to macbook over USB LAN
        # make sure to set macbook LAN interface to 192.168.99.x/24
        address = "192.168.99.20";
        prefixLength = 24;
      }];

    };

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ 41641 ];
    };
  };

  systemd.targets = {
    # do not sleep after inactivity
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  virtualisation.docker.enable = true;
  nixpkgs.config.allowUnfree = true;

  fonts.fonts = with pkgs; [
    jetbrains-mono
    san-francisco-font
  ];

  environment.systemPackages = with pkgs; [
    age
    alacritty
    deno
    firefox
    git
    go
    google-chrome
    neofetch
    python310
    tailscale
    vim
    vscode
    wget

    # gui apps
    blueman
    gnome.gnome-disk-utility
    gnome.nautilus
    mpv
    networkmanagerapplet
    open-sans
    # pavucontrol
  ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  users.mutableUsers = false;
  security.sudo.execWheelOnly = true;

  users.users.charlie = {
    name = "charlie";
    shell = pkgs.fish;
    isNormalUser = true;
    hashedPassword = "$6$31S1yCMSMoOOfGxQ$E9ApKvVw3C/E5Qe.lIF1TlsagFkzeNsxN/o0kfnB0QA.787omwkQLfpvdMclsL3oeFFun0ixP1VpNzMkDHPj81";
    home = "/home/charlie";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBN2Ha30vOLebdfcyLZyDxYU5o8USrjyWu2DiG+ZLdJ1S1LJ95QWDcxB50pUAfOlN5NgAP8LF2QAKO3K9eZd1nnM="
    ];
  };

  programs = {
    fish.enable = true;
    sway = {
      enable = true;
      extraPackages = with pkgs; [ waybar wofi ];
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
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
      };
    };

    openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
    };

    tailscale = {
      enable = true;
      port = 41641;
    };
  };

  system.stateVersion = "21.11";
}

