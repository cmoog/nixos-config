{ config, pkgs, ... }: {

  imports = [ ./hardware-configuration.nix ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 80 443 ];
      allowedUDPPorts = [ config.services.tailscale.port ];
      checkReversePath = "loose";
    };
  };

  virtualisation.docker.enable = true;

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
      # yubikey 5c
      "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBCQxol3q/6oj04K/OTJ+T/TX2hbeqJ5FU/UoiiuE6M7pqYJeYb3cfKvYjA8tuFLl+fDnUIVDgSEKBpBROuMGWnAAAAAEc3NoOg=="
      # yubikey 5c nfc
      "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBFOAtDtX07lwPCT9mPLh3ipHupxKUotmVVyx4fmjMdUClorv/2rDXK9tfZzvlzXUFDsF/4t1q2wseqpmxp590tAAAAAEc3NoOg=="
    ];
  };

  users.mutableUsers = false;
  security.sudo.execWheelOnly = true;

  programs = {
    fish.enable = true;
  };

  services = {
    tailscale = {
      enable = true;
      port = 41641;
    };
  };

  system.stateVersion = "21.11";
}
