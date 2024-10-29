{ inputs, pkgs, lib, config, ... }:

{
  home.packages = with pkgs; [
    nerdfonts
  ]; 
}
