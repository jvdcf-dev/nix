{ inputs, pkgs, lib, config, ... }:

{
  home.packages = with pkgs; [
    neovim
  ]; 

  home.file = {
    ".config/nvim/init.lua".source = ./init.lua;
    ".config/nvim/lua".source = ./lua;
    ".config/nvim/themes".source = ./themes;
    ".config/nvim/.stylua.toml".source = ./.stylua.toml;
  };
}
