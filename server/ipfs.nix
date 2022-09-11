{ config, pkgs, ... }:
{
  # ipfs http gateway
  # TODO: support subdomain routing scheme
  services.nginx.virtualHosts."ipfs.*" = {
    locations."/" = {
      proxyPass = "http://localhost:8001";
      proxyWebsockets = true;
    };
  };
  virtualisation.oci-containers.containers = {
    ipfs = {
      image = "ipfs/kubo@sha256:3bc49baa89b6c5f665de04771baf83c390b9ac6a6a7c7463fda3f3e9ff244f7f";
      volumes = [
        "ipfs-data:/data/ipfs"
        "ipfs-staging:/export"
      ];
      ports = [
        "127.0.0.1:5001:5001"
        "127.0.0.1:4001:4001"
        "127.0.0.1:8001:8080"
      ];
    };
  };
}
