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
      kernel.cachyos = {
        enable = true;
        package = pkgs.cachyosKernels.linuxPackages-cachyos-server-lto;
      };
      power.profile = "performance";
      virtualization = {
        docker = true;
        qemuUserAarch64 = true;
      };
    };

    service = {
      agenix.enable = true;
      fhs.enable = true;
      mihomo.enable = true;
      tailscale.enable = true;
    };
  };

  security.sudo.wheelNeedsPassword = false;
}
