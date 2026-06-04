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

    features = {
      cpu.intel.enable = true;
      firmware.enable = true;
      gpu.intel.enable = true;
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
        qemuUserAarch64 = true;
      };
      tailscale.enable = true;
    };
  };

  security.sudo.wheelNeedsPassword = false;
}
