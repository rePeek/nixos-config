{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./filesystem.nix
  ];

  custom.hardware = {
    bluetooth.enable = true;
    boot.mode = "uefi";
    cpu.intel.enable = true;
    firmware.enable = true;
    gpu.nvidia.enable = true;
    kernel.cachyos = {
      enable = true;
      package = pkgs.cachyosKernels.linuxPackages-cachyos-lts-lto-x86_64-v3;
    };
    storage.ssd.enable = true;
  };
}
