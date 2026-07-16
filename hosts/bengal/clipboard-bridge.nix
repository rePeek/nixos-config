# Work around WeLink/Wine clipboard updates racing Hyprland's XWayland focus checks.
{ ... }:

{
  home-manager.users.asen.custom.desktop.hyprland.welinkClipboardBridge.enable = true;
}
