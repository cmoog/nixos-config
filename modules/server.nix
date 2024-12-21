{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.moog.server;
in
{
  options.moog.server = {
    enable = lib.mkEnableOption "Enable a server configuration.";
  };
  config = lib.mkIf cfg.enable {
    systemd.targets = {
      # do not sleep after inactivity
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };

    networking = {
      firewall = {
        enable = true;
        checkReversePath = "loose";
      };
    };

    services = {
      openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
        };
      };
    };
  };
}
