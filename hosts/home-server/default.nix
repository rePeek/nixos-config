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

  custom = {
    boot.mode = "uefi";

    features = {
      graphics.enable = true;
      power.profile = "efficiency";
      virtualization = {
        docker = true;
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
