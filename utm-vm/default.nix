{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  server.enable = true;

  networking.hostName = "charlie-vm";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  virtualisation.docker.enable = true;

  nix = {
    distributedBuilds = true;
    buildMachines = [{
      hostName = "nuc.cmoog.io";
      protocol = "ssh-ng";
      system = "x86_64-linux";
      sshUser = "charlie";
      maxJobs = 100;
    }];
  };

  users.users.charlie = {
    name = "charlie";
    shell = pkgs.fish;
    isNormalUser = true;
    hashedPassword =
      "$6$31S1yCMSMoOOfGxQ$E9ApKvVw3C/E5Qe.lIF1TlsagFkzeNsxN/o0kfnB0QA.787omwkQLfpvdMclsL3oeFFun0ixP1VpNzMkDHPj81";
    home = "/home/charlie";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      (import ../home/ssh.nix).macNoAuth
    ];
  };
  users.mutableUsers = false;

  system.stateVersion = "21.11";
}
