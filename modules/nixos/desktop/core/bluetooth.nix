{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.custom.desktop.enable {
    hardware.bluetooth.enable = lib.mkDefault true;
    hardware.bluetooth.powerOnBoot = lib.mkDefault true;

    environment.systemPackages = [
      pkgs.bluez
    ];
  };
}
