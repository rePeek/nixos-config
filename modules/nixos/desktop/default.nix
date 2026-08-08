{ lib, ... }:

{
  imports = [
    ../server
    ./avatar.nix
    ./core
    ./gaming.nix
    ./nvidia.nix
    ./shell
    ./theme.nix
  ];

  config = {
    custom = {
      desktop = {
        theme = {
          enable = lib.mkDefault true;
          image = lib.mkDefault ../../../assets/wallpapers/a_woman_with_long_hair_wearing_sunglasses.png;
        };
        avatar.enable = lib.mkDefault true;
      };
    };
  };
}
