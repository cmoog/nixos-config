{ pkgs, ... }:
{

  imports = [ ./hardware-configuration.nix ];

  moog.gui.enable = false;
  moog.server.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "charlie-nuc";
  };

  users.users.charlie = {
    name = "charlie";
    shell = pkgs.fish;
    isNormalUser = true;
    hashedPassword = "$6$31S1yCMSMoOOfGxQ$E9ApKvVw3C/E5Qe.lIF1TlsagFkzeNsxN/o0kfnB0QA.787omwkQLfpvdMclsL3oeFFun0ixP1VpNzMkDHPj81";
    home = "/home/charlie";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = builtins.attrValues (import ../home/ssh.nix);
  };
  users.mutableUsers = false;

  system.stateVersion = "21.11";
}
