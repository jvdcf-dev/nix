{ inputs, pkgs, lib, config, ... }:

{
	home.packages = with pkgs; [
	  kitty
  ];

  home.file.".config/kitty/kitty.conf".source = ./kitty.conf;
  home.file.".config/kitty/current-theme.conf".source = ./current-theme.conf;
}
