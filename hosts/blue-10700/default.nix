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

    ../../modules/nixos/core
    ../../modules/nixos/extraServices/fhs.nix
    ../../modules/nixos/extraServices/tailscale.nix
    ../../modules/nixos/extraServices/virtualization.nix
    ../../modules/nixos/extraServices/mihomo.nix
    ../../modules/nixos/extraServices/agenix.nix
  ];

  custom.service.agenix.enable = true;
  custom.service.fhs.enable = true;
  custom.service.mihomo.enable = true;
  custom.service.virtualization = {
    enable = true;
    docker = true;
  };
  custom.service.tailscale.enable = true;
}
