{ inputs, ... }:
{
  imports = [
    (inputs.nixos-hardware + "/common/cpu/intel/jasper-lake")
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix
    ./filesystem.nix
  ];

  hardware.enableRedistributableFirmware = true;
}
