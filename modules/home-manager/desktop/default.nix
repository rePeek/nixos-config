{ pkgs, ... }:
{
  imports = [
    ./dms.nix
    ./hyprland.nix
  ];

  home.packages = [
    pkgs.wechat
  ];
}
