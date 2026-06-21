# Enable the generic graphics stack for desktop, gaming, and media workloads.
{
  config,
  lib,
  ...
}:

let
  cfg = config.custom.desktop.graphics;
in
{
  options.custom.desktop.graphics = {
    enable = lib.mkEnableOption "hardware accelerated graphics stack";

    compat32.enable = lib.mkEnableOption "32-bit graphics drivers for Wine, Steam, and Proton";
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = cfg.compat32.enable;
    };
  };
}
