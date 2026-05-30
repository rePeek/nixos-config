{
  config,
  lib,
  ...
}:

let
  cfg = config.custom.desktop.bluetooth;
in
{
  options.custom.desktop.bluetooth.enable = lib.mkEnableOption "Blueman GUI for Bluetooth";

  config = lib.mkIf (config.custom.service.desktop.enable && cfg.enable) {
    assertions = [
      {
        assertion = config.custom.hardware.bluetooth.enable;
        message = "custom.desktop.bluetooth.enable requires custom.hardware.bluetooth.enable = true;";
      }
    ];

    services.blueman.enable = true;
  };
}
