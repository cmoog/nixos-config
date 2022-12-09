{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self, nixpkgs, home-manager, nixpkgs-unstable }:
    let
      system = "x86_64-linux";
      overlay = final: prev: {
        unstable = import nixpkgs-unstable { inherit system; };
        # force home-manager programs.lazygit to use unstable lazygit
        # (home-manager overlays don't work)
        lazygit = final.unstable.lazygit;
      };
      overlays = [ overlay ];
      overlay-module = ({ config, pkgs, ... }: {
        nixpkgs.overlays = overlays;
      });
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      formatter.${system} = pkgs.nixpkgs-fmt;
      homeConfigurations.charlie = home-manager.lib.homeManagerConfiguration rec {
        inherit system;
        inherit (configuration.home) stateVersion username homeDirectory;
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
