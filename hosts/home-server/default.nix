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

    ./service

    ../../modules/nixos
  ];

  custom = {
    boot.mode = "uefi";

    users = {
      enabled = [ "asen" ];
      asen = {
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
        ];
        extraAuthorizedKeys = [
          # Windows game PC
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGRn9IstM5aV2WO9aiT1XeGUKw/2aN+VR5GGYx0tny1 game@brain"
        ];
      };
    };

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
      tailscale = {
        advertiseExitNode = true;
        enable = true;
      };
      cli-proxy-api = {
        enable = true;
        listenAddress = "0.0.0.0";
        port = 8317;
        openFirewall = true;
      };
    };
  };

  security.sudo.wheelNeedsPassword = false;
}
