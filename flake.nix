# ──────────╮
# Nix Flake │
# ──────────╯
# @jvdcf
# Template by Vimjoyer (https://www.youtube.com/watch?v=rEovNpg7J0M)
# Where all package sources are defined and "locked" in a commit.
# It is also the entry point for the NixOS configuration.

{
  description = "@jvdcf's NixOS config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-24-11.url = "github:nixos/nixpkgs?ref=release-24.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
  };

  outputs =
    { nixpkgs, nixpkgs-24-11, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs-stable = nixpkgs-24-11.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        SillyBilly = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system;
            inherit pkgs-stable;
          };
          modules = [
            ./nixos/configuration.nix
            inputs.home-manager.nixosModules.default
            inputs.stylix.nixosModules.stylix
          ];
        };
      };
    };
}
