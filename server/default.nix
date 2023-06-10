{ config, ... }: {

  imports = [
    ./gitbrowser.nix
    ./metrics.nix
    ./nginx.nix
  ];

  systemd.targets = {
    # do not sleep after inactivity
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  services = {
    vscode-server.enable = true;
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };
}
