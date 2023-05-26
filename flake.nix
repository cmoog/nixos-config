{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server = {
      url = "github:msteen/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };
  outputs =
    { self, nixpkgs, home-manager, nixpkgs-unstable, vscode-server, stylix }:
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
        modules = [ stylix.nixosModules.stylix overlay-module ./home.nix ];
      };
      nixosConfigurations.charlie-nuc = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          overlay-module
          stylix.nixosModules.stylix
          vscode-server.nixosModule

          ./desktop/gui.nix
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
