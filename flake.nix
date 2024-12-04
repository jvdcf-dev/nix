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
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        SillyBilly = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit system; };
          modules = [
            ./nixos/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
      };
    };
}
