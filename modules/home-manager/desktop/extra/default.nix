# Optional GUI applications for desktop Home Manager roles.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.custom.desktop.extra.enable = lib.mkEnableOption "extra desktop applications";

  config = lib.mkIf config.custom.desktop.extra.enable {
    home.packages = [
      pkgs.calibre
      pkgs.discord
      pkgs.koodo-reader
      pkgs.obs-studio
      pkgs.qbittorrent-enhanced
      pkgs.telegram-desktop
      pkgs.wiliwili
    ];
  };
}
