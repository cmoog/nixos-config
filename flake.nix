{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      overlays = [
        (final: prev: {
          unstable = import inputs.nixpkgs-unstable { system = prev.system; };
        })
      ];
      defaultModules = [
        home-manager.nixosModules.default
        ./modules
        ./common.nix
        {
          nixpkgs.overlays = overlays;
          _module.args = { inherit inputs; };
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            users.charlie = import ./home;
          };
        }
      ];
      forEach = systems: f:
        nixpkgs.lib.genAttrs systems
          (system: f (import nixpkgs { inherit system overlays; }));
      systems = [ "x86_64-linux" "aarch64-linux" ];
    in
    {
      formatter = forEach systems (pkgs: pkgs.nixpkgs-fmt);
      packages = forEach systems (pkgs: {
        homeConfig = (home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home ];
          extraSpecialArgs = { inherit inputs; };
        }).activationPackage;
      });
      nixosModules.default = ./modules;
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
          modules = [ ./pi { _module.args = { inherit inputs; }; } ];
        };
      };
    };
}
