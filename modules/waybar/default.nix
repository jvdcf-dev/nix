{ inputs, pkgs, lib, config, ... }:

{
  home.packages = with pkgs; [
    waybar
  ]; 

  home.file = {
    ".config/waybar/config".source = ./config;
    ".config/waybar/frappe.css".source = ./frappe.css;
    ".config/waybar/style.css".source = ./style.css;
  };
}
