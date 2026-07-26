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
        "input"
      ];
    };

    home.users.asen.extraPackages = with pkgs; [
      libva-utils
      mesa-demos
      vulkan-tools
    ];

    core = {
      kernel.cachyos = {
        enable = true;
        package = pkgs.cachyosKernels.linuxPackages-cachyos-latest-zen4;
      };
    };

    desktop = {
      gaming.enable = true;
    };

    server = {
      fhs.enable = true;
    };
  };

  security.sudo.wheelNeedsPassword = false;
}
