{
  lib,
  ...
}:

{
  options.custom.desktop.enable = lib.mkEnableOption "desktop profile";

  imports = [
    ../server
    ./amd.nix
    ./audio.nix
    ./bluetooth.nix
    ./core
    ./components
    ./graphics.nix
    ./nvidia.nix
    ./shell
    ./tools.nix
  ];

  config = {
    custom = {
      desktop = {
        enable = lib.mkDefault true;
        audio.enable = lib.mkDefault true;
        bluetooth.enable = lib.mkDefault true;
        graphics.enable = lib.mkDefault true;
        shell.enable = lib.mkDefault true;
        theme = {
          enable = lib.mkDefault true;
          image = lib.mkDefault ../../../assets/wallpapers/a_woman_with_long_hair_wearing_sunglasses.png;
        };
        components = {
          avatar.enable = lib.mkDefault true;
        };
      };
    };
  };
}
