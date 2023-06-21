{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server = {
      url = "github:msteen/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self, nixpkgs, home-manager, vscode-server }:
    let
      forEach = systems: f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
      mkSystem = { system, hostname, modules ? [ ] }:
        let
          overlay = final: prev: { };
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            vscode-server.nixosModule
            ./common.nix
            home-manager.nixosModule
            {
              networking.hostName = hostname;
              nixpkgs.overlays = [ overlay ];
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.charlie = import ./home.nix;
              };
            }
          ] ++ modules;
        };
    in
    {
      formatter = forEach [ "x86_64-linux" "aarch64-linux" ] (pkgs: pkgs.nixpkgs-fmt);
      packages = forEach [ "x86_64-linux" "aarch64-linux" ] (pkgs: {
        homeConfig = (home-manager.lib.homeManagerConfiguration rec {
          inherit pkgs;
          modules = [ ./home.nix ];
        }).activationPackage;
      });
      nixosConfigurations.charlie-vm = mkSystem {
        system = "aarch64-linux";
        hostname = "charile-vm";
        modules = [ ./utm-vm ];
      };
      nixosConfigurations.charlie-nuc = mkSystem {
        system = "x86_64-linux";
        hostname = "charile-nuc";
        modules = [ ./intel-nuc ];
      };
    };
}
