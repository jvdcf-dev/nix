# ───────────────────────╮
# Nix user configuration │
# ───────────────────────╯
# @jvdcf
# Dotfiles, applications and envs for only my user are defined here.

{ pkgs, pkgs-stable, pipewire-screenaudio, lib, ... }:

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
    (firefox.override { nativeMessagingHosts = [ 
      pipewire-screenaudio.packages.${pkgs.system}.default 
    ]; })
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
    youtube-music
    direnv
    jetbrains-toolbox
    steam-run
    rlwrap
    nixd
    nixfmt-rfc-style
    texlive.combined.scheme-full  # LaTeX support
    kdePackages.qtmultimedia      # Fokus widget (for pomodoro timer)
    kde-rounded-corners
    kdePackages.plasma-browser-integration
    anytype
    vlc
    gnome-software
    fragments              # Torrent client
  ] ++ (with pkgs-stable; [
    bottles
  ]);


  # Remove Home Manager backups
  # ==========================================================================

  home.file = {
    "/home/jvdcf/.gtkrc-2.0".force = lib.mkDefault true;
    "/home/jvdcf/.config/fontconfig/conf.d/10-hm-fonts.conf".force = lib.mkDefault true;
  };
    

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
