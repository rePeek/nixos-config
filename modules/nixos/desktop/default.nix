{
  config,
  lib,
  ...
}:

{
  options.custom.desktop.enable = lib.mkEnableOption "desktop profile";

  imports = [
    ./base.nix
    ./gaming.nix
    ./input-method

    ./shell
  ];
}
