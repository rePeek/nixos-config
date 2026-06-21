{
  config,
  lib,
  osConfig ? null,
  pkgs,
  ...
}:
let
  osDesktopEnabled = osConfig != null && osConfig.custom.desktop.enable;
in
{
  options.custom.desktop.enable = lib.mkEnableOption "desktop Home Manager profile" // {
    default = osDesktopEnabled;
  };

  imports = [
    ./defaults
    ./dms.nix
    ./hyprland.nix
  ];

  config.home.packages = lib.mkIf config.custom.desktop.enable [
    pkgs.wechat
  ];
}
