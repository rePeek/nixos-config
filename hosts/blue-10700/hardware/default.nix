{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./filesystem.nix
  ];

  custom.boot.mode = "uefi";

  custom.hardware = {
    cpu.intel.enable = true;
    firmware.enable = true;
    kernel.cachyos = {
      enable = true;
      package = pkgs.cachyosKernels.linuxPackages-cachyos-server-lto;
    };
    storage.ssd.enable = true;
  };
}
