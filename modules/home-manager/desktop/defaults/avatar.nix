# User avatar fallbacks for the desktop profile.
{
  config,
  lib,
  osConfig ? null,
  ...
}:

let
  cfg =
    if osConfig == null then
      {
        enable = false;
        manageHomeFallback = false;
        users = { };
      }
    else
      osConfig.custom.desktop.components.avatar;
in
{
  config =
    lib.mkIf
      (
        config.custom.desktop.enable
        && cfg.enable
        && cfg.manageHomeFallback
        && lib.hasAttr config.home.username cfg.users
      )
      {
        home.file = {
          ".face".source = cfg.users.${config.home.username};
          ".face.icon".source = cfg.users.${config.home.username};
        };
      };
}
