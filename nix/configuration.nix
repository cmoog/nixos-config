# NixOS configuration.nix
{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "charlie-nuc";

  time.timeZone = "America/Chicago";

  networking.useDHCP = false;
  networking.interfaces.enp5s0.useDHCP = true;
  networking.wireless.enable = false;

  networking.interfaces.eno1.useDHCP = false;
  networking.interfaces.eno1.ipv4.addresses = [{
    # static local IP for connecting directly to macbook over USB LAN
    # make sure to set macbook LAN interface to 192.168.99.x/24
    address = "192.168.99.20";
    prefixLength = 24;
  }];

  # do not sleep after inactivity
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Enable the GNOME Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  virtualisation.docker.enable = true;
  programs.fish.enable = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    age
    alacritty
    unstable.deno
    firefox
    fish
    git
    go
    google-chrome
    htop
    neovim
    python310
    tailscale
    vim
    vscode
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
    isNormalUser = true;
    hashedPassword = "$6$31S1yCMSMoOOfGxQ$E9ApKvVw3C/E5Qe.lIF1TlsagFkzeNsxN/o0kfnB0QA.787omwkQLfpvdMclsL3oeFFun0ixP1VpNzMkDHPj81";
    home = "/home/charlie";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBN2Ha30vOLebdfcyLZyDxYU5o8USrjyWu2DiG+ZLdJ1S1LJ95QWDcxB50pUAfOlN5NgAP8LF2QAKO3K9eZd1nnM="
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
  };

  services.tailscale.enable = true;
  services.tailscale.port = 41641;
  # these might be needed for tailscale exit node, but I haven't gotten them working yet
  # boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  # boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

  # firewall
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [ 41641 ];

  # don't change
  system.stateVersion = "21.11";
}

