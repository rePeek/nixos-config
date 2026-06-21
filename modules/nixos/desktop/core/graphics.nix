# Enable the generic graphics stack for desktop, gaming, and media workloads.
{
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.custom.desktop.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
