# bluetooth.nix
# Configure Bluetooth support for hosts that have Bluetooth hardware.
{ config, lib, ... }:

let
  cfg = config.custom.desktop.bluetooth;
in
{
  options.custom.desktop.bluetooth.enable = lib.mkEnableOption "Bluetooth support";

  config = lib.mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
  };
}
