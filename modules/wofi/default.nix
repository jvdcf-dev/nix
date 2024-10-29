{ inputs, pkgs, lib, config, ... }:

{
  home.packages = with pkgs; [
    wofi
  ]; 

  home.file = {
    ".config/wofi/config".source = ./config;
    ".config/wofi/style.css".source = ./style.css;
  };
}
