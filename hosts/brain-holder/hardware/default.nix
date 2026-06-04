{ inputs, ... }:
{
  imports = [
    # The Intel iGPU is currently disabled in firmware. Use
    # /common/cpu/intel/alder-lake instead if it is enabled later.
    (inputs.nixos-hardware + "/common/cpu/intel/alder-lake/cpu-only.nix")
    (inputs.nixos-hardware + "/common/gpu/nvidia/ada-lovelace")
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix
    ./filesystem.nix
  ];

  hardware.enableRedistributableFirmware = true;
}
