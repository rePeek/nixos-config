{
  config,
  pkgs,
  modulesPath,
  lib,
  ...
}:

{
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-server-lto;
  networking.hostName = "Blue-10700";

  imports = [
    ./hardware
    ./network.nix
    ./user.nix

    ../../modules/nixos
    ../../modules/nixos/extraServices/tailscale.nix
    ../../modules/nixos/extraServices/virtualization.nix
    ../../modules/nixos/extraServices/mihomo.nix
    ../../modules/nixos/extraServices/agenix.nix
  ];

  myModule.agenix.enable = true;
  modules.network.clash.enable = true;
  modules.virtualization.custom.docker = true;
}
