{ inputs, pkgs, lib, config, ... }:

{
  home.packages = with pkgs; [
    hyprland
    xdg-desktop-portal-hyprland
    dconf
    xwayland
    xwaylandvideobridge
    polkit-kde-agent
    hypridle
    hyprlock
    hyprpaper

    brightnessctl
    pavucontrol
    grim
    wl-clipboard
    slurp
    playerctl
  ]; 

  home.file = {
    ".config/hypr/hyprland.conf".source = ./hyprland.conf;
    ".config/hypr/frappe.conf".source = ./frappe.conf;
    ".config/hypr/hypridle.conf".source = ./hypridle.conf;
    ".config/hypr/hyprlock.conf".source = ./hyprlock.conf;
    ".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
  };
}
