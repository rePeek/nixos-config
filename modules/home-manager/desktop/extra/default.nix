# Optional GUI applications for desktop Home Manager roles.
# All apps are managed via Flatpak; packages here are merged
# with the base list in general/flatpak.nix.
{
  config,
  lib,
  ...
}:
{
  options.custom.desktop.extra.enable = lib.mkEnableOption "extra desktop applications";
  config = lib.mkIf config.custom.desktop.extra.enable {
    services.flatpak.packages = [
      "cn.xfangfang.wiliwili"
      "com.calibre_ebook.calibre"
      "com.discordapp.Discord"
      "com.obsproject.Studio"
      "io.github.troyeguo.koodo-reader"
      "org.qbittorrent.qBittorrent"
      "org.telegram.desktop"
    ];
  };
}
