{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  server.enable = true;

  networking.hostName = "charlie-vm";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
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
    ];
  };
  users.mutableUsers = false;

  system.stateVersion = "21.11";
}
