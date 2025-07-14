# ───────────────────────╮
# Nix user configuration │
# ───────────────────────╯
# @jvdcf
# Dotfiles, applications and envs for only my user are defined here.

{ pkgs, pkgs-stable, lib, inputs, ... }:

{
  imports = [
    ../modules  # Dotfiles and respective apps are inside /modules
  ];

  # Home Manager
  # ==========================================================================

  home.username = "jvdcf";
  home.homeDirectory = "/home/jvdcf";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Applications
  # ==========================================================================

  home.packages = with pkgs; [
    # Terminal
    bottom
    neovim
    steam-run
    lazygit
    rlwrap
    bat
    eza
    procs
    dust
    tokei
    hyperfine
    tealdeer
    libnotify

    # Programming
    vscode
    direnv
    nixd
    nixfmt-rfc-style
    texlive.combined.scheme-full  # LaTeX support
    zed-editor

    # KDE Addons
    kdePackages.qtmultimedia      # Fokus widget (for pomodoro timer)
    vscode-runner          # VSCode workspaces in KDE Runner

    nextcloud-client
    (firefox.override { nativeMessagingHosts = [ 
      inputs.pipewire-screenaudio.packages.${pkgs.system}.default 
    ]; })
    gnome-calendar
    gnome-clocks
    gnome-calculator
    papers # Gnome document viewer
    nautilus
    libreoffice
    parsec-bin
    discord
    wine
    youtube-music
    jetbrains-toolbox
    kde-rounded-corners
    kdePackages.plasma-browser-integration
    vlc
    gnome-software
    fragments              # Torrent client
    moonlight-qt
    bottles
    anytype
    obs-studio
    thunderbird
  ] ++ (with pkgs-stable; [
    # Place here apps that are broken in unstable
  ]) ++ [
    inputs.zen-browser.packages."${system}".beta
  ];

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
