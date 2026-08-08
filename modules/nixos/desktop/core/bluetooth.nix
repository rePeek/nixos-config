{ lib, ... }:

{
  config = {
    hardware.bluetooth.enable = lib.mkDefault true;
    hardware.bluetooth.powerOnBoot = lib.mkDefault true;
  };
}
