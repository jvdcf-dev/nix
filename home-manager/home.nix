# ───────────────────────╮
# Nix user configuration │
# ───────────────────────╯
# @jvdcf
# Dotfiles, applications and envs for only my user are defined here.

{ pkgs, ... }:

{

  # Home Manager
  # ==========================================================================

  home.username = "jvdcf";
  home.homeDirectory = "/home/jvdcf";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;


  # Applications
  # ==========================================================================

  imports = [
    ../modules  # Dotfiles and respective apps are inside modules/
  ];

  home.packages = with pkgs; [
    btop
    vscode
    nextcloud-client
    bottles
    firefox
    gnome-calendar
    gnome-clocks
    gnome-calculator
    papers # Gnome document viewer
    nautilus
    libreoffice
    neovim
    parsec-bin
    webcord
    wine
    bottles
    youtube-music
    direnv
    jetbrains-toolbox
    steam-run
    rlwrap
    nixd
    nixfmt-rfc-style
  ];

  fonts.fontconfig.enable = true;


  # ==========================================================================

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

}
