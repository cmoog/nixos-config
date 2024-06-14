{ pkgs, lib, ... }: {
  imports = [ ./hardware-configuration.nix ];

  moog.server.enable = true;

  networking.hostName = "charlie-vm";
  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  environment.systemPackages = with pkgs; [
    compsize
  ];

  virtualisation.rosetta.enable = true;

  nix = {
    distributedBuilds = false;
    buildMachines = [{
      hostName = "charlie-nuc";
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
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      (import ../home/ssh.nix).macNoAuth
    ];
  };
  users.mutableUsers = false;
  services.tailscale.enable = lib.mkForce false;

  home-manager.users.charlie = {
    programs.git.extraConfig = {
      # stored in secure enclave on macbook-air with auth required
      user.signingKey = "key::ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGxStcvVFF2s/4GFuLj8ehTzzD1B8Ct9Ntds1G1WONyEUShl8oHoZiByjObeX2wyfJx3ZpzhJ/A7Wa73bTL85Yk= ecdsa-sha2-nistp256";
      gpg.format = "ssh";
      commit.gpgsign = true;
      tag.gpgsign = true;
    };
  };

  system.stateVersion = "21.11";
}
