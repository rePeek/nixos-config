{
  pkgs,
  ...
}:
let
  sessionPackage =
    (pkgs.writeTextDir "share/wayland-sessions/hyprland-dms.desktop" ''
      [Desktop Entry]
      Name=Hyprland DMS
      Comment=Hyprland session using DankMaterialShell configuration
      Exec=Hyprland -c ''${HOME}/.config/hypr/hyprland.lua
      Type=Application
      DesktopNames=Hyprland
    '').overrideAttrs
      (_: {
        passthru.providedSessions = [ "hyprland-dms" ];
      });

in
{
  inherit sessionPackage;
}
