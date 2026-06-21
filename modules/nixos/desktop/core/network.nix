{ config, lib, ... }:
{
  config = lib.mkIf config.custom.desktop.enable {
    networking.networkmanager.enable = lib.mkDefault true;
  };
}
