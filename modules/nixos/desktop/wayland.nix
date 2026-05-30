{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.custom.service.desktop.enable {
    programs.hyprland = {
      enable = true;
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
        pkgs.xdg-desktop-portal-hyprland
      ];
    };
  };
}
