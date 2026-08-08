{ lib, ... }:
{
  config = {
    networking.networkmanager.enable = lib.mkDefault true;
  };
}
