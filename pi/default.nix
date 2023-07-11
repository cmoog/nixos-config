{ config, pkgs, lib, modulesPath, ... }: {

  imports = [
    # "${modulesPath}/installer/sd-card/sd-image-raspberrypi.nix"
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
  };

  users.users.nixos = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBN2Ha30vOLebdfcyLZyDxYU5o8USrjyWu2DiG+ZLdJ1S1LJ95QWDcxB50pUAfOlN5NgAP8LF2QAKO3K9eZd1nnM="
    ];
  };

  sdImage.compressImage = false;

  networking.hostName = "pi";

  networking.wireless = {
    enable = false;
    iwd.enable = true;
  };

  services.openssh.enable = true;

  system.stateVersion = "23.05";
}
