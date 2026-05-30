{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./filesystem.nix
  ];

  custom.boot.mode = "uefi";

  custom.hardware = {
    audio.enable = true;
    bluetooth.enable = true;
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
