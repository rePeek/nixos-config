{
  lib,
  ...
}:

{
  options.custom.desktop.enable = lib.mkEnableOption "desktop profile";

  imports = [
    ./core
    ./addons
    ./shell
  ];
}
