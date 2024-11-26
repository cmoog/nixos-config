{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  moog.server.enable = true;
  moog.gui.enable = false;
  moog.gui.variant = "gnome";

  networking.hostName = "charlie-vm";
  # allow access to all ports from host via bridge network
  networking.firewall.enable = lib.mkForce false;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  environment.systemPackages = with pkgs; [ compsize ];

  system.build.isoInstaller = import ./iso.nix {
    device = "/dev/vda";
    systemToInstall = config.system.build.toplevel;
    inherit lib;
    system = pkgs.system;
  };

  systemd.oomd = {
    enable = true;
    enableSystemSlice = true;
    enableRootSlice = true;
    enableUserSlices = true;
  };

  services.chrony = {
    extraConfig = ''
      server 3.nixos.pool.ntp.org iburst minpoll 6 maxpoll 7 maxsources 3
    '';
  };

  virtualisation.rosetta.enable = pkgs.system == "aarch64-linux";

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ];
  };

  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "charlie-nuc";
        protocol = "ssh-ng";
        system = "x86_64-linux";
        sshUser = "charlie";
        maxJobs = 100;
      }
    ];
  };

  users.users.charlie = {
    name = "charlie";
    shell = pkgs.fish;
    isNormalUser = true;
    hashedPassword = "$6$31S1yCMSMoOOfGxQ$E9ApKvVw3C/E5Qe.lIF1TlsagFkzeNsxN/o0kfnB0QA.787omwkQLfpvdMclsL3oeFFun0ixP1VpNzMkDHPj81";
    home = "/home/charlie";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys =
      let
        keys = import ../home/ssh.nix;
      in
      [
        keys.macSecEnc
        keys.mac
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
