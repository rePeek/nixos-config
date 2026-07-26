# NixOS configuration for amur.
{ pkgs, ... }:
{
  networking.hostName = "amur";

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
        "libvirtd"
        "docker"
      ];
    };

    home.users.asen = {
      extraPackages = with pkgs; [
        libva-utils
        mesa-demos
        vulkan-tools
      ];

      desktop.extra.enable = true;

      desktop.hyprland.outputRules = [
        {
          output = "desc:Microstep MAG 271QPX E2";
          mode = "2560x1440@239.99";
          position = "auto";
          scale = "1";
        }
      ];
    };

    core.kernel.cachyos = {
      enable = true;
      package = pkgs.cachyosKernels.linuxPackages-cachyos-latest-zen4;
    };

    server = {
      fhs.enable = true;
      agenix.enable = true;
      mihomo.enable = true;

      virtualization = {
        docker = true;
        libvirtd = {
          enable = true;
          kvm.cpu = "amd";
        };
      };
    };

    desktop = {
      nvidia.compute.enable = true;
      nvidia.driver.enable = true;
      gaming = {
        enable = true;
        cs2.enable = true;
      };
    };
  };

  services.leigod-plugin = {
    enable = false;
    physicalInterface = "wlp14s0";
  };
}
