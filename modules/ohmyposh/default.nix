{ inputs, pkgs, lib, config, ... }:

{
  home.packages = with pkgs; [
    oh-my-posh
  ];

  home.file.".config/ohmyposh/ohmyposh.toml".source = ./ohmyposh.toml;
}
