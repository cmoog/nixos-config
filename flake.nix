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
  };
  outputs =
    { self, nixpkgs, home-manager, nixpkgs-unstable, vscode-server }:
    let
      systems = [
        {
          system = "x86_64-linux";
          hostname = "charlie-nuc";
        }
        {
          system = "aarch64-linux";
          hostname = "charlie-vm";
        }
      ];
      mkSystem = { system, hostname, modules ? [ ] }:
        let
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
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            overlay-module
            vscode-server.nixosModule
            ./common.nix
            home-manager.nixosModule
            {
              networking.hostName = hostname;
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
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.nixpkgs-fmt;
      # homeConfigurations.charlie = home-manager.lib.homeManagerConfiguration rec {
      #   modules = [ overlay-module ./home.nix ];
      # };
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
