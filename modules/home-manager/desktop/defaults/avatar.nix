# User avatar fallbacks for the desktop profile.
{
  config,
  lib,
  osConfig ? null,
  ...
}:

let
  desktop =
    if osConfig == null then
      {
        enable = false;
        components = { };
      }
    else
      osConfig.custom.desktop;
  cfg =
    desktop.components.avatar or {
      enable = false;
      manageHomeFallback = false;
      users = { };
    };
in
{
  config = lib.mkIf (desktop.enable && cfg.enable && cfg.manageHomeFallback) {
    home.file = lib.mkIf (lib.hasAttr config.home.username cfg.users) {
      ".face".source = cfg.users.${config.home.username};
      ".face.icon".source = cfg.users.${config.home.username};
    };
  };
}
