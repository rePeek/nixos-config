{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.custom.desktop.extra.enable = lib.mkEnableOption "extra desktop applications";
  config = lib.mkIf config.custom.desktop.extra.enable {
    home.packages = with pkgs; [
      obs-studio
    ];
    services.flatpak.packages = [
      "org.telegram.desktop"
    ];
    services.flatpak.overrides."org.telegram.desktop".Context.filesystems = [
      "xdg-download/Telegram Desktop:create"
    ];
    services.flatpak.overrides."org.telegram.desktop".Environment = {
      QT_QPA_PLATFORMTHEME_QT6 = "xdgdesktopportal";
    };
  };
}
