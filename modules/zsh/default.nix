{ inputs, pkgs, lib, config, ... }:

{
  home.packages = with pkgs; [
    zsh
    zoxide
    fzf
  ]; 

  home.file = {
    ".zshrc".source = ./.zshrc;
  };
}
