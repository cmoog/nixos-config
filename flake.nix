{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, nixpkgs-unstable, neovim-nightly-overlay }:
    let
      system = "x86_64-linux";
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations.charlie-nuc = nixpkgs.lib.nixosSystem
        {
          inherit system;
          modules = [
            ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable neovim-nightly-overlay.overlay ]; })
            ./nix/configuration.nix
            home-manager.nixosModule
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.charlie = import ./nix/home.nix;
              };
            }
          ];
        };
    };
}
