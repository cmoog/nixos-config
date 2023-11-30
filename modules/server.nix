{ pkgs, lib, config, ... }:
let
  cfg = config.server;
in
with lib; {
  options.server = {
    enable = mkEnableOption "Enable a server configuration.";
  };
  config = mkIf cfg.enable {
    systemd.targets = {
      # do not sleep after inactivity
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };

    virtualisation.docker.enable = true;

    networking = {
      firewall = {
        enable = true;
        allowedTCPPorts = [ 22 80 443 ];
        allowedUDPPorts = [ config.services.tailscale.port ];
        checkReversePath = "loose";
      };
    };

    services = {
      tailscale = {
        enable = true;
        port = 41641;
      };
      openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
        };
      };

      vscode-server.enable = true;
    };
  };
}
