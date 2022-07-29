{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self, nixpkgs, home-manager, nixpkgs-unstable, neovim-nightly-overlay }:
    let
      system = "x86_64-linux";
      overlay = final: prev: {
        san-francisco-font =
          prev.callPackage ./desktop/san-francisco-font.nix { };
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
      overlays = [ overlay neovim-nightly-overlay.overlay ];
      overlay-module = ({ config, pkgs, ... }: {
        nixpkgs.overlays = overlays;
      });
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
      homeConfigurations.charlie = home-manager.lib.homeManagerConfiguration rec {
        inherit system;
        stateVersion = configuration.home.stateVersion;
        username = configuration.home.username;
        homeDirectory = configuration.home.homeDirectory;
        configuration = import ./home.nix rec {
          pkgs = import nixpkgs { inherit system overlays; };
          config = pkgs.config;
        };
      };
      nixosConfigurations.charlie-nuc = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          overlay-module
          ./configuration.nix
          home-manager.nixosModule
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.charlie = import ./home.nix;
            };
          }
        ];
      };
    };
}
