{ modulesPath, lib, inputs, pkgs, ... }: {

  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64-installer.nix"
  ];

  boot = {
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
    kernelParams = [
      "8250.nr_uarts=1"
      # ttyAMA0 is the serial console broken out to the GPIO
      "console=ttyAMA0,115200"
      "console=tty1"
      "cma=128M"
    ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  hardware.deviceTree.filter = "bcm2711-rpi-*.dtb";
  hardware.bluetooth.enable = false;

  security.sudo.wheelNeedsPassword = false;
  users.mutableUsers = false;
  users.users.cmoog = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = with (import ../home/ssh.nix); [
      macNoAuth
      vm
    ];
    hashedPassword = null;
    extraGroups = [ "wheel" ];
  };

  sdImage.compressImage = false;

  networking.hostName = "pi4";

  networking.wireless = {
    enable = false; # this is mutually exclusive with `iwd.enable`
    iwd.enable = true;
  };

  networking.interfaces.end0.useDHCP = false;
  networking.interfaces.end0.ipv4.addresses = [{
    address = "169.254.74.161";
    prefixLength = 24;
  }];

  environment.systemPackages = with pkgs; [
    btop
    curl
    fish
    git
    vim
  ];
  environment.shellAliases = { "ip" = "ip --color=auto"; };

  services.openssh.enable = true;
  services.tailscale.enable = true;
  hardware.enableRedistributableFirmware = true;

  nix = {
    registry.nixpkgs.flake = inputs.nixpkgs;
    channel.enable = false;
    settings = {
      experimental-features = [ "flakes" "nix-command" ];
      trusted-users = [ "@wheel" ];
      builders-use-substitutes = true;
    };
  };

  system.stateVersion = "23.11";
}
