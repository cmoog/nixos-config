{ config, pkgs, ... }:

{
  systemd.services.gotty = {
    description = "Run gotty btop";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.gotty}/bin/gotty --address localhost --port 2342 ${pkgs.btop}/bin/btop";
    };
  };
}
