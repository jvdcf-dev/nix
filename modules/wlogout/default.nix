{ inputs, pkgs, lib, config, ... }:

{
  home.packages = with pkgs; [
    wlogout
  ]; 

  home.file = {
    ".config/wlogout/frappe.css".source = ./frappe.css;
    ".config/wlogout/style.css".source = ./style.css;
    ".config/wlogout/layout".source = ./layout;
  };
}
