# Optional GUI applications for desktop Home Manager roles.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  telegramDesktopX11 = pkgs.symlinkJoin {
    name = "telegram-desktop-x11";
    paths = [ pkgs.telegram-desktop ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram "$out/bin/Telegram" \
        --set QT_QPA_PLATFORM xcb \
        --set QT_IM_MODULE fcitx \
        --set XMODIFIERS '@im=fcitx'
    '';
  };
in
{
  options.custom.desktop.extra.enable = lib.mkEnableOption "extra desktop applications";

  config = lib.mkIf (config.custom.desktop.enable && config.custom.desktop.extra.enable) {
    home.packages = [
      pkgs.calibre
      pkgs.discord
      pkgs.koodo-reader
      pkgs.obs-studio
      pkgs.qbittorrent-enhanced
      telegramDesktopX11
      pkgs.wiliwili
    ];
  };
}
