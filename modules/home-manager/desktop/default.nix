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
  options.custom.desktop.enable = lib.mkEnableOption "desktop Home Manager role" // {
    default = osDesktopEnabled;
  };

  imports = [
    ../server
    ./browser.nix
    ./documents.nix
    ./files.nix
    ./input-method.nix
    ./media.nix
    ./office.nix
    ./terminal.nix
    ./wallpaper.nix
    ./dms
  ];

  config.home.packages = lib.mkIf config.custom.desktop.enable [
    pkgs.wechat
  ];
}
