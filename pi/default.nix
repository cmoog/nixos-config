{ modulesPath, ... }: {

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
      (import ../home/ssh.nix).macNoAuth
    ];
  };

  sdImage.compressImage = false;

  networking.hostName = "pi";

  networking.wireless = {
    enable = false; # this is mutually exclusive with `iwd.enable`
    iwd.enable = true;
  };

  services.openssh.enable = true;

  system.stateVersion = "23.05";
}
