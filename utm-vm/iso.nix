{
  systemToInstall,
  device,
  system,
  lib,
}:

let
  module =
    {
      pkgs,
      config,
      modulesPath,
      ...
    }:

    {
      imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-base.nix" ];
      environment.systemPackages = [ config.system.build.installer ];
      system.build.installer = pkgs.writeShellApplication {
        name = "installer";
        runtimeInputs = with pkgs; [
          parted
          e2fsprogs
          nixos-install-tools
          btrfs-progs
        ];
        text = ''
          target="${device}"

          printf "label: gpt\n,550M,U\n,,L\n" | sfdisk ''${target}

          mkfs.fat -F 32 ''${target}1
          fatlabel ''${target}1 boot
          mkfs.btrfs ''${target}2
          btrfs filesystem label ''${target}2 root
          mkdir -p /mnt
          mount ''${target}2 /mnt
          btrfs subvolume create /mnt/root
          btrfs subvolume create /mnt/home
          btrfs subvolume create /mnt/nix
          umount /mnt

          mount -o compress=zstd,subvol=root ''${target}2 /mnt
          mkdir /mnt/{home,nix}
          mount -o compress=zstd,subvol=home ''${target}2 /mnt/home
          mount -o compress=zstd,noatime,subvol=nix ''${target}2 /mnt/nix
          mkdir /mnt/boot
          mount ''${target}1 /mnt/boot

          nixos-install --no-channel-copy \
            --no-root-passwd \
            --system ${systemToInstall}
        '';
      };

    };
in
(lib.nixosSystem {
  inherit system;
  modules = [ module ];
}).config.system.build.isoImage
