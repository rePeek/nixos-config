{
  config,
  pkgs,
  modulesPath,
  lib,
  ...
}:

{
  networking.hostName = "Blue-10700";

  imports = [
    ./hardware
    ./network.nix
    ./user.nix

    ../../modules/nixos
  ];

  custom = {
    boot.mode = "uefi";

    hardware = {
      cpu.intel.enable = true;
      firmware.enable = true;
      kernel.cachyos = {
        enable = true;
        package = pkgs.cachyosKernels.linuxPackages-cachyos-server-lto;
      };
      storage.ssd.enable = true;
    };

    service = {
      agenix.enable = true;
      fhs.enable = true;
      mihomo.enable = true;
      power.profile = "performance";
      virtualization = {
        docker = true;
      };
      tailscale.enable = true;
    };
  };
}
