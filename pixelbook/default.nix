{ pkgs, lib, ... }: {
  imports = [ ./hardware-configuration.nix ];

  moog.gui.enable = true;

  networking = {
    hostName = "charlie-laptop";
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  hardware = {
    opengl.enable = true;
  };

  users.users.charlie = {
    name = "charlie";
    shell = pkgs.fish;
    isNormalUser = true;
    hashedPassword =
      "$6$31S1yCMSMoOOfGxQ$E9ApKvVw3C/E5Qe.lIF1TlsagFkzeNsxN/o0kfnB0QA.787omwkQLfpvdMclsL3oeFFun0ixP1VpNzMkDHPj81";
    home = "/home/charlie";
    extraGroups = [ "wheel" "wireshark" ];
  };
  users.mutableUsers = true;
  security.sudo.execWheelOnly = true;

  programs = {
    ssh.startAgent = true;
  };

  home-manager.users.charlie = {
    programs.git.extraConfig = {
      commit.gpgsign = lib.mkForce false;
      tag.gpgsign = lib.mkForce false;
    };
  };

  services = {
    tailscale.enable = true;
  };

  system.stateVersion = "23.05";
}
