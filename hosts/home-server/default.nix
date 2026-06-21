# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  ...
}:
{
  networking.hostName = "home-server";

  imports = [
    ./hardware
    ./network

    ./service

    ../../modules/nixos/server
  ];

  custom = {
    boot.mode = "uefi";

    server = {
      agenix.enable = true;
      fhs.enable = true;
      mihomo.enable = true;
      cli-proxy-api = {
        enable = true;
        listenAddress = "0.0.0.0";
        port = 8317;
        openFirewall = true;
      };

      virtualization = {
        docker = true;
      };
    };

    core.tailscale = {
      advertiseExitNode = true;
    };

  };

  security.sudo.wheelNeedsPassword = false;

  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
  users.users.root.openssh.authorizedKeys.keys = config.custom.ssh.sharedAuthorizedKeys;
}
