# NixOS configuration.nix
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./server/gitbrowser.nix
    ./server/metrics.nix
    ./server/nginx.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = "America/Chicago";

  networking = {
    hostName = "charlie-nuc";

    useDHCP = false;
    networkmanager.enable = true;
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
      allowedTCPPorts = [ 22 80 443 ];
      allowedUDPPorts = [ config.services.tailscale.port ];
      checkReversePath = "loose";
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

  environment.systemPackages = with pkgs; [
    age
    deno
    git
    go
    python310
    tailscale
    vim
    wget
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
    hashedPassword =
      "$6$31S1yCMSMoOOfGxQ$E9ApKvVw3C/E5Qe.lIF1TlsagFkzeNsxN/o0kfnB0QA.787omwkQLfpvdMclsL3oeFFun0ixP1VpNzMkDHPj81";
    home = "/home/charlie";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      # secure enclave of mac, no auth required
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBN2Ha30vOLebdfcyLZyDxYU5o8USrjyWu2DiG+ZLdJ1S1LJ95QWDcxB50pUAfOlN5NgAP8LF2QAKO3K9eZd1nnM="
    ];
  };

  programs = {
    fish.enable = true;
  };

  services = {
    openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
    };

    tailscale = {
      enable = true;
      port = 41641;
    };
    vscode-server.enable = true;
  };

  system.stateVersion = "21.11";
}

