# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  ...
}:
{
  imports = [
    ./hardware

    ./user.nix
    ./network.nix

    ../../modules/nixos
    ../../modules/nixos/extraServices/tailscale.nix
    ../../modules/nixos/extraServices/virtualization.nix
    ../../modules/nixos/extraServices/dae.nix
  ];

  modules.network.daed.enable = true;
  modules.virtualization.custom.docker = true;
}
