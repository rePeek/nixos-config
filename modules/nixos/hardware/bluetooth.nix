# bluetooth.nix
# Configure Bluetooth support for hosts that have Bluetooth hardware.
{ config, lib, ... }:

let
  cfg = config.custom.hardware.bluetooth;
in
{
  options.custom.hardware.bluetooth.enable = lib.mkEnableOption "Bluetooth support";

  config = lib.mkIf cfg.enable {
    # Use bluetoothctl for CLI pairing and blueman for GUI pairing.
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
