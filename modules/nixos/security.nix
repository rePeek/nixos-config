{ lib, ... }:
{
  security.sudo = {
    enable = true;
    wheelNeedsPassword = lib.mkDefault true;
  };
  security.polkit.enable = true;
}
