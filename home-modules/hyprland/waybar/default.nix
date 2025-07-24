{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    waybar
  ];

  home.file.".config/waybar/config".source = ./config;
  home.file.".config/waybar/style.css".source = ./style.css;
  home.file.".config/waybar/frappe.css".source = ./frappe.css;
}
