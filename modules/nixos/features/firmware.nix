# firmware.nix
# Enable redistributable firmware for physical hosts that require it.
{ config, lib, ... }:

let
  cfg = config.custom.features.firmware;
in
{
  options.custom.features.firmware.enable = lib.mkEnableOption "redistributable firmware";

  config = lib.mkIf cfg.enable {
    hardware.enableRedistributableFirmware = true;
  };
}
