{
  pkgs,
  inputs,
  config,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    curl
    git
    helix
    vim
  ];

  services.timesyncd.enable = false;
  services.chrony.enable = true;

  boot.loader.systemd-boot.configurationLimit = 10;

  security.sudo.execWheelOnly = true;
  security.sudo.wheelNeedsPassword = false;

  programs.fish.enable = true;
  programs.nano.enable = false;
  programs.command-not-found.enable = false;

  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      unstable.flake = inputs.nixpkgs-unstable;
    };
    channel.enable = false;
    optimise.automatic = true; # runs `nix store optimise` daily
    settings = {
      nix-path = config.nix.nixPath;
      experimental-features = [
        "ca-derivations"
        "fetch-closure"
        "flakes"
        "nix-command"
      ];
      trusted-users = [ "@wheel" ];
      auto-optimise-store = false; # don't optimise during builds
      builders-use-substitutes = true;
    };
  };
}
