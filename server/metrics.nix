{ config, pkgs, ... }:

{
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
}
