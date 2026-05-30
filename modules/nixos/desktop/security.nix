{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.custom.service.desktop.enable {
    security.rtkit.enable = true;
    security.polkit.enable = true;
    security.sudo.enable = true;
    security.pam.services.hyprlock = { };
  };
}
