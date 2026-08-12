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
  };
}
