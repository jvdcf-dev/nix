{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    swaynotificationcenter
  ];

  home.file.".config/swaync/config.json".source = ./config.json;
  home.file.".config/swaync/frappe.css".source = ./frappe.css;
  home.file.".config/swaync/style.css".source = ./style.css;
}
