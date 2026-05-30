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
  ];

  custom.service.agenix.enable = true;
  custom.service.fhs.enable = true;
  custom.service.mihomo.enable = true;
  custom.service.power.profile = "efficiency";
  custom.service.virtualization = {
    docker = true;
  };
  custom.service.tailscale.enable = true;
}
