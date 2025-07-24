{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    fastfetch
  ];

  home.file.".config/fastfetch/config.jsonc".source = ./config.jsonc;
  home.file.".config/fastfetch/logo.txt".source = ./logo.txt;
}
