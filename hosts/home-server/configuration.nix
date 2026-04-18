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

    ../../modules/nixos
    ../../modules/nixos/extraServices/tailscale.nix
    ../../modules/nixos/extraServices/virtualization.nix
    ../../modules/nixos/extraServices/mihomo.nix
  ];

  modules.network.clash.enable = true;
  modules.virtualization.custom.docker = true;
}
