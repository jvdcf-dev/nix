{
  pkgs,
  ...
}:

{
  imports = [
    ./fuzzel
    # ./swaync  # Deativated due to KDE conflit
    ./waybar
    ./wlogout
    ./wofi
  ];

  home.packages = with pkgs; [
    hyprcursor
    hyprpaper
    hyprlock
    hypridle
    hyprpicker
    hyprsunset
    brightnessctl
    wl-clipboard
    blueberry
    pavucontrol
    networkmanagerapplet
  ];

  home.file.".config/hypr/frappe.conf".source = ./frappe.conf;
  home.file.".config/hypr/hypridle.conf".source = ./hypridle.conf;
  home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
  home.file.".config/hypr/hyprlock.conf".source = ./hyprlock.conf;
  home.file.".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;

  home.sessionVariables.HYPRCURSOR_THEME = "Catppuccin-Frappe-Green";
}
