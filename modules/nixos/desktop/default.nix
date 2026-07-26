{
  lib,
  ...
}:

{
  options.custom.desktop.enable = lib.mkEnableOption "desktop profile";

  imports = [
    ../server
    ./avatar.nix
    ./core
    ./cs2.nix
    ./gaming.nix
    ./nvidia.nix
    ./shell
    ./terminal.nix
    ./theme.nix
  ];

  config = {
    custom = {
      desktop = {
        enable = lib.mkDefault true;
        shell.enable = lib.mkDefault true;
        theme = {
          enable = lib.mkDefault true;
          image = lib.mkDefault ../../../assets/wallpapers/a_woman_with_long_hair_wearing_sunglasses.png;
        };
        avatar.enable = lib.mkDefault true;
      };
    };
  };
}
