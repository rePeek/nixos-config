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
      # GNOME 50 needs the 25.08 codecs. Explicitly retain their parent runtime
      # so --unused cleanup cannot remove it and autodelete the shared codecs.
      "org.freedesktop.Platform//25.08"
      "org.freedesktop.Platform.codecs-extra//25.08-extra"
    ];
    services.flatpak.overrides."org.telegram.desktop".Context.filesystems = [
      "xdg-download/Telegram Desktop:create"
    ];
    services.flatpak.overrides."org.telegram.desktop".Environment = {
      QT_QPA_PLATFORMTHEME_QT6 = "xdgdesktopportal";
    };
  };
}
