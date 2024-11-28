{ inputs, pkgs, config, ... }:

{
    # home.stateVersion = "21.03";
    imports = [
      ./fastfetch
      ./kitty
      ./zsh
      ./ohmyposh
    ];

    #home.packages = with pkgs; [
    #  unzip
    #  tree
    #  btop
    #  nextcloud-client
    #  kdePackages.kdeconnect-kde
    #  parsec-bin
    #  webcord
    #  jetbrains-toolbox
    #  vscode
    #  spotify
    #  libreoffice
    #];
}
