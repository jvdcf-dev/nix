# ───────────────────────╮
# Nix user configuration │
# ───────────────────────╯
# @jvdcf
# Dotfiles, applications and envs for only my user are defined here.

{
  pkgs,
  pkgs-stable,
  lib,
  ...
}:

{
  # Dotfiles and respective apps are inside /home-modules
  imports = [
    ../home-modules/fastfetch
    ../home-modules/ghostty
    ../home-modules/helix
    # ../home-modules/hyprland
    ../home-modules/kitty
    ../home-modules/ohmyposh
    ../home-modules/zed
    ../home-modules/zsh
  ];

  # Home Manager
  # ==========================================================================

  home.username = "jvdcf";
  home.homeDirectory = "/home/jvdcf";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Applications
  # ==========================================================================

  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
    nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];
  };

  home.packages =
    with pkgs;
    [
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
      vscodium
      direnv
      nixd
      nixfmt-rfc-style
      texlive.combined.scheme-full # LaTeX support
      docker-compose

      # KDE Addons
      kdePackages.qtmultimedia # Fokus widget (for pomodoro timer)
      vscode-runner # VSCode workspaces in KDE Runner
      kde-rounded-corners

      # KDE default apps
      kdePackages.discover
      kdePackages.merkuro
      kdePackages.korganizer
      kdePackages.kcontacts
      kdePackages.kcalc
      kdePackages.okular
      kdePackages.ktorrent
      kdePackages.kcolorchooser
      kdePackages.ksystemlog
      kdePackages.isoimagewriter
      kdePackages.filelight
      kdePackages.kclock
      haruna

      nextcloud-client
      libreoffice
      parsec-bin
      discord
      wine
      youtube-music
      jetbrains-toolbox
      vlc
      moonlight-qt
      bottles
      obs-studio
      thunderbird
      ktailctl
    ]
    ++ (with pkgs-stable; [
      # Place here apps that are broken in unstable
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
