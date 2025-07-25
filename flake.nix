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
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=release-24.11";
    pipewire-screenaudio.url = "github:IceDBorn/pipewire-screenaudio";
    pipewire-screenaudio.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs-stable = nixpkgs-stable.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        SillyBilly = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit system;
            inherit pkgs-stable;
            inherit home-manager;
          };
          modules = [
            home-manager.nixosModules.default
            inputs.aagl.nixosModules.default
            inputs.stylix.nixosModules.stylix
            inputs.lanzaboote.nixosModules.lanzaboote
            ./laptop/configuration.nix
          ];
        };
      };
    };
}
