{ pkgs, config, ... }:
let
  proxyConf = (port: {
    addSSL = true;
    sslCertificateKey = "/etc/ssl/certs/_wildcard.nuc.cmoog.io-key.pem";
    sslCertificate = "/etc/ssl/certs/_wildcard.nuc.cmoog.io.pem";
    locations."/" = {
      proxyPass = "http://localhost:${port}";
      proxyWebsockets = true;
    };
  });
in
{
  services.nginx = {
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
    virtualHosts."git.*" = proxyConf "8999";
    virtualHosts."top.*" = proxyConf "2342";
    virtualHosts."8998.*" = proxyConf "8998";
    virtualHosts."9000.*" = proxyConf "9000";
  };
}
