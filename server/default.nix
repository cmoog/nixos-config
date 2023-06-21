{ pkgs, config, ... }: {

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

  services = {
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
      virtualHosts."kalshi.*".locations."/" = {
        proxyPass = "http://localhost:8998";
        proxyWebsockets = true;
      };
    };
  };
}
