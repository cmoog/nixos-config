{ config, pkgs, ... }:

let
  port = "8999";
in
{
  services.nginx.virtualHosts."git.*" = {
    locations."/" = {
      proxyPass = "http://localhost:${port}";
      proxyWebsockets = true;
    };
  };
  virtualisation.oci-containers.containers = {
    gitiles = {
      image = "bauerd/gitiles@sha256:7b53109489a76d6437344c8a93783f2ea1dad96a2c74d15b5b457dbc993c9d42";
      volumes = [
        "/home/${config.users.users.charlie.name}/Code:/var/repos:ro"
      ];
      ports = [
        "127.0.0.1:${port}:8080"
      ];
      environment = {
        SITE_TITLE = "cmoogsource";
        CANONICAL_HOST_NAME = config.networking.hostName;
        BASE_GIT_URL = "ssh://nuc.cmoog.io/~/Code/";
      };
    };
  };
}
