{ pkgs, ... }:

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
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
  };
}
