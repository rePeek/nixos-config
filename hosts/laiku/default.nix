# Desktop profile for the Lecoo MINI PRO-AHP host.
{ pkgs, ... }:

{
  networking.hostName = "laiku";

  imports = [
    ./hardware
    ./network.nix

    ../../modules/nixos/desktop
  ];

  custom = {
    boot.mode = "uefi";

    users = {
      enabled = [ "asen" ];
      asen.extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };

    core = {
      kernel.cachyos = {
        enable = true;
        package = pkgs.cachyosKernels.linuxPackages-cachyos-latest-zen4;
      };
    };

    desktop = {
      amd.enable = true;
      gaming.enable = true;
    };

    server = {
      fhs.enable = true;
    };
  };

  security.sudo.wheelNeedsPassword = false;
}
