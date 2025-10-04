{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # https://github.com/helix-editor/helix/pull/12098
    # helix.url = "github:helix-editor/helix/a238b9457ba761fc1423dc35119eef76d01a3a5c";
    helix.url = "github:helix-editor/helix";
  };
  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      helix,
      ...
    }@inputs:
    let
      overlays = [
        (final: prev: {
          unstable = import nixpkgs-unstable { system = prev.system; };
          helix = helix.packages.${prev.system}.helix;
        })
      ];
      defaultModules = [
        home-manager.nixosModules.default
        ./modules
        ./common.nix
        {
          nixpkgs.overlays = overlays;
          _module.args = {
            inherit inputs;
          };
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit inputs;
            };
            users.charlie = import ./home;
          };
        }
      ];
      forEach =
        systems: f: nixpkgs.lib.genAttrs systems (system: f (import nixpkgs { inherit system overlays; }));
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    in
    {
      formatter = forEach systems (pkgs: pkgs.nixfmt-rfc-style);
      packages = forEach systems (pkgs: {
        homeConfig =
          (home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./home ];
            extraSpecialArgs = {
              inherit inputs;
            };
          }).activationPackage;
      });
      nixosModules.default = ./modules;
      nixosConfigurations = {
        charlie-vm = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [ ./utm-vm ] ++ defaultModules;
        };
        charlie-vm-x86 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./utm-vm
            { nixpkgs.hostPlatform = "x86_64-linux"; }
          ]
          ++ defaultModules;
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
          modules = [
            ./pi
            ./common.nix
            {
              _module.args = {
                inherit inputs;
              };
              nixpkgs.overlays = overlays;
            }
          ];
        };
      };
    };
}
