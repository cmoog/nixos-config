{ pkgs, inputs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    go
    vim
    wget
  ];

  security.sudo.execWheelOnly = true;
  security.sudo.wheelNeedsPassword = false;

  programs.fish.enable = true;

  programs.command-not-found.enable = false;

  # for easy reference to generation source
  environment.etc."current-nixos".source = ./.;

  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    package = pkgs.nixUnstable;
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      unstable.flake = inputs.nixpkgs-unstable;
    };
    channel.enable = false;
    optimise.automatic = true; # runs `nix store optimise` daily
    settings = {
      nix-path = config.nix.nixPath;
      experimental-features = [ "nix-command" "flakes" "fetch-closure" "repl-flake" ];
      trusted-users = [ "@wheel" ];
      auto-optimise-store = false; # don't optimise during builds
      builders-use-substitutes = true;
    };
  };
}
