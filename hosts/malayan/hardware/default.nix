{ inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix
    ./filesystem.nix
  ];
}
