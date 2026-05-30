{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.custom.service.desktop.enable {
    security.pam.services.hyprlock = { };
  };
}
