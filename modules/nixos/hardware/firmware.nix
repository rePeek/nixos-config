# firmware.nix
# Enable redistributable firmware for physical hosts that require it.
{ config, lib, ... }:

let
  cfg = config.custom.hardware.firmware;
in
{
  options.custom.hardware.firmware.enable = lib.mkEnableOption "redistributable firmware";

  config = lib.mkIf cfg.enable {
    hardware.enableRedistributableFirmware = true;
  };
}
