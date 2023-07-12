{ pkgs, ... }:

{
  imports = [
    ./server
  ];

  time.timeZone = "America/Chicago";

  environment.systemPackages = with pkgs; [
    git
    go
    vim
    wget
  ];

  nix = {
    package = pkgs.nixUnstable;
    settings.experimental-features = [ "nix-command" "flakes" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };
  };
}
