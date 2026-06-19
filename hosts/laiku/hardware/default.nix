{ inputs, ... }:
{
  imports = [
    (inputs.nixos-hardware + "/common/cpu/amd")
    (inputs.nixos-hardware + "/common/cpu/amd/pstate.nix")
    (inputs.nixos-hardware + "/common/gpu/amd")
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix
    ./filesystem.nix
  ];

  hardware.enableRedistributableFirmware = true;
}
