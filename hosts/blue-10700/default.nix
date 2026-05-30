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

  custom.service.agenix.enable = true;
  custom.service.fhs.enable = true;
  custom.service.mihomo.enable = true;
  custom.service.power.profile = "performance";
  custom.service.virtualization = {
    docker = true;
  };
  custom.service.tailscale.enable = true;
}
