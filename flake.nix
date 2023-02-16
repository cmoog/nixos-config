{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server = {
      url = "github:msteen/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };
  outputs =
    { self, nixpkgs, home-manager, nixpkgs-unstable, vscode-server }:
    let
      system = "x86_64-linux";
      overlay = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
        # force home-manager programs.lazygit to use unstable lazygit
        # (home-manager overlays don't work)
        lazygit = final.unstable.lazygit;
      };
      overlays = [ overlay ];
      overlay-module = ({ config, pkgs, ... }: {
        nixpkgs.overlays = overlays;
      });
      pkgs = import nixpkgs { inherit system; };
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
          vscode-server.nixosModule
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
