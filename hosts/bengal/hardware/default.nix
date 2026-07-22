{ inputs, ... }:
{
  imports = [
    (inputs.nixos-hardware + "/common/cpu/intel/comet-lake")
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix
    ./filesystem.nix
  ];

  hardware.enableRedistributableFirmware = true;
}
