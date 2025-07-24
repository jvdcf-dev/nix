{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    wlogout
  ];

  home.file.".config/wlogout/layout".source = ./layout;
  home.file.".config/wlogout/style.css".source = ./style.css;
  home.file.".config/wlogout/frappe.css".source = ./frappe.css;
}
