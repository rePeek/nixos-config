# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:
{
  networking.hostName = "sumatran";

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
      mihomo = {
        enable = true;
        directUdpSourceCidrs = [ "192.168.50.134/32" ];
      };
      # cpa.enable = true;

      virtualization = {
        docker = true;
      };
    };

    # core.tailscale = {
    #   advertiseExitNode = true;
    # };

  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = [ pkgs.tdl ];

  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
  users.users.root.openssh.authorizedKeys.keys = config.custom.ssh.sharedAuthorizedKeys;
}
