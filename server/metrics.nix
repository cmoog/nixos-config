{ config, pkgs, ... }:

{
  services.nginx.virtualHosts."dash.*" = {
    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.grafana.port}";
      proxyWebsockets = true;
    };
  };
  services.grafana = {
    enable = true;
    port = 2342;
    addr = "localhost";

    users.allowSignUp = false;
    users.allowOrgCreate = false;
    auth.anonymous.enable = false;

    provision = {
      enable = true;
      datasources = [
        {
          name = "prometheus";
          isDefault = true;
          type = "prometheus";
          url = "http://localhost:${toString config.services.prometheus.port}";
        }
      ];
      dashboards = [{
        name = "Metrics";
        type = "file";
        disableDeletion = true;
        options.path = ./dashboard.json;
      }];
    };
  };

  services.prometheus = {
    enable = true;
    port = 9001;

    scrapeConfigs = [{
      job_name = "node-exporter";
      static_configs = [{
        targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
      }];
    }];

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
    };
  };
}
