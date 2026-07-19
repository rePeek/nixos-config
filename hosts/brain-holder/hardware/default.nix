{ inputs, ... }:
{
  imports = [
    (inputs.nixos-hardware + "/common/cpu/amd")
    (inputs.nixos-hardware + "/common/gpu/nvidia/ada-lovelace")
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix
    ./filesystem.nix
  ];

  hardware.enableRedistributableFirmware = true;
}
