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
  outputs = { self, nixpkgs, home-manager, vscode-server }:
    let
      forEach = systems: f: nixpkgs.lib.genAttrs systems (system: f
        nixpkgs.legacyPackages.${system});
      defaultModules = [
        home-manager.nixosModules.default
        vscode-server.nixosModules.default
        ./modules/server.nix
        ./modules/gui.nix
        ./common.nix
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.charlie = import
              ./home.nix;
          };
        }
      ];
    in
    {
      formatter = forEach [ "x86_64-linux" "aarch64-linux" ] (pkgs: pkgs.nixpkgs-fmt);
      packages =
        forEach [ "x86_64-linux" "aarch64-linux" ] (pkgs: {
          homeConfig = (home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./home.nix ];
          }).activationPackage;
        });
      nixosConfigurations = {
        charlie-vm = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [ ./utm-vm ] ++ defaultModules;
        };
        charlie-nuc = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./intel-nuc ] ++ defaultModules;
        };
        charlie-laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./pixelbook ] ++ defaultModules;
        };
        pi4 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [ ./pi ];
        };
      };
    };
}
