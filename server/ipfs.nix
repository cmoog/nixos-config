{ config, pkgs, ... }:
let
  gatewayPort = "8001";
in
{
  # ipfs http gateway
  # TODO: add config for subdomain routing
  # see: https://github.com/ipfs-shipyard/go-ipfs-docker-examples/blob/5976a5255bee70043cb00aca8a89cac729e03709/gateway/ipfs-config.sh#L39
  services.nginx.virtualHosts."ipfs.*".locations."/" = {
    proxyPass = "http://localhost:${gatewayPort}";
    proxyWebsockets = true;
  };
  networking.firewall = {
    allowedUDPPorts = [ 4001 ];
  };

  services.ipfs = {
    enable = true;
    gatewayAddress = "/ip4/127.0.0.1/tcp/${gatewayPort}";
  };

  # virtualisation.oci-containers.containers.ipfs = {
  #   image = "ipfs/kubo@sha256:3bc49baa89b6c5f665de04771baf83c390b9ac6a6a7c7463fda3f3e9ff244f7f";
  #   volumes = [
  #     "ipfs-data:/data/ipfs"
  #     "ipfs-staging:/export"
  #   ];
  #   ports = [
  #     # api (tcp)
  #     "127.0.0.1:5001:5001"
  #     # swarm (quic)
  #     "4001:4001"
  #     # gateway (tcp)
  #     "127.0.0.1:${gatewayPort}:8080"
  #   ];
  # };
}
