{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./filesystem.nix
  ];

  custom.hardware = {
    boot.mode = "uefi";
    cpu.intel.enable = true;
    firmware.enable = true;
    kernel.cachyos = {
      enable = true;
      package = pkgs.cachyosKernels.linuxPackages-cachyos-server-lto;
    };
    storage.ssd.enable = true;
  };
}
