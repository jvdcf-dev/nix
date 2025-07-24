{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    zed-editor
  ];

  home.file.".config/zed/config.json".source = ./config.json;
}
