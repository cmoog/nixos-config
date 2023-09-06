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
    };
  };
}
