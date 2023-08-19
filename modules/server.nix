{ pkgs, lib, config, ... }:
let
  cfg = config.server;
in
with lib; {
  options.server = {
    enable = mkEnableOption "Enable a server configuration.";
  };
  config = mkIf cfg.enable {
    systemd.services.gotty = {
      description = "Run gotty btop";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.gotty}/bin/gotty \
            --port 2342 \
            --address localhost \
            ${pkgs.btop}/bin/btop
        '';
      };
    };

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

      cgit."git.*" = {
        enable = true;
        scanPath = "/home/charlie/Code";
      };

      nginx = {
        enable = true;
        recommendedProxySettings = true;
        virtualHosts."_" = {
          default = true;
          extraConfig = ''
            add_header content-type text/plain;
          '';
          locations."/" = {
            return = "200 'hello from ${config.networking.hostName}'";
          };
        };
        virtualHosts."top.*".locations."/" = {
          proxyPass = "http://localhost:2342";
          proxyWebsockets = true;
        };
      };
    };
  };
}
