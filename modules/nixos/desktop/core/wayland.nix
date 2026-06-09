{
  pkgs,
  pkgsUnstable,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.custom.desktop.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      package = pkgsUnstable.hyprland;
      portalPackage = pkgsUnstable.xdg-desktop-portal-hyprland;
    };
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = [ "gtk" ];
        hyprland.default = [
          "gtk"
          "hyprland"
        ];
      };
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgsUnstable.xdg-desktop-portal-hyprland
      ];
    };
  };
}
