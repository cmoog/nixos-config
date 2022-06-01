{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
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
      overlay = final: prev: {
        san-francisco-font = prev.callPackage ./desktop/san-francisco-font.nix { };
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
            ({ config, pkgs, ... }: {
              nixpkgs.overlays = [
                overlay
                neovim-nightly-overlay.overlay
              ];
            })
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
