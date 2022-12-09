{ config, pkgs, ... }:

{
  services.grafana = {
    enable = true;

    settings = {
      users.allow_sign_up = false;
      users.allow_org_create = false;
      "auth.anonymous".enabled = false;
      server = {
        http_port = 2342;
        http_addr = "localhost";
      };
    };

    provision = {
      enable = true;
      dashboards.settings.providers = [{
        name = "Metrics";
        type = "file";
        disableDeletion = true;
        options.path = ./dashboard.json;
      }];
      datasources.settings.datasources = [
        {
          name = "prometheus";
          isDefault = true;
          type = "prometheus";
          url = "http://localhost:${toString config.services.prometheus.port}";
        }
      ];
    };
  };

  services.prometheus = {
    enable = true;
    port = 9001;
    listenAddress = "127.0.0.1";

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
        listenAddress = "127.0.0.1";
      };
    };
  };
}
