{ pkgs, inputs, ... }:

{
  time.timeZone = "America/Chicago";

  environment.systemPackages = with pkgs; [
    git
    go
    vim
    wget
  ];

  security.sudo.execWheelOnly = true;
  programs.fish.enable = true;

  # for easy reference to generation source
  environment.etc."current-nixos".source = ./.;

  nix = {
    package = pkgs.nixUnstable;
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      unstable.flake = inputs.nixpkgs-unstable;
    };
    channel.enable = false;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "@wheel" ];
    };
  };
}
