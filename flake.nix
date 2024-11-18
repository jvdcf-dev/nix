{
  description = "@jvdcf development config";
  # Template by Vimjoyer (https://www.youtube.com/watch?v=rEovNpg7J0M)

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };

  in {
    nixosConfigurations = {
      SillyBilly = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit system;};
        modules = [
          ./nixos/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
  };
}
