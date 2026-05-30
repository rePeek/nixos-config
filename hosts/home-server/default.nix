# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  ...
}:
{
  networking.hostName = "home-server";

  imports = [
    ./hardware
    ./network

    ./user.nix

    ../../modules/nixos/core
    ../../modules/nixos/fhs.nix
    ../../modules/nixos/extraServices/tailscale.nix
    ../../modules/nixos/extraServices/virtualization.nix
    ../../modules/nixos/extraServices/mihomo.nix
    ../../modules/nixos/extraServices/agenix.nix
  ];

  custom.service.agenix.enable = true;
  custom.service.mihomo.enable = true;
  custom.service.virtualization = {
    enable = true;
    docker = true;
  };
  custom.service.tailscale.enable = true;
}
