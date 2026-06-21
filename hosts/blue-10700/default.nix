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

    ../../modules/nixos
    ../../modules/nixos/desktop
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

    home.users.asen.desktop.hyprland.outputRules = [
      {
        output = "DP-1";
        mode = "preferred";
        position = "auto";
        scale = "1";
        transform = 2;
      }
    ];

    features = {
      audio.enable = true;
      bluetooth.enable = true;
      graphics.enable = true;
      kernel.cachyos = {
        enable = true;
        package = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;
      };
      power.profile = "performance";
      virtualization = {
        docker = true;
        qemuUserAarch64 = true;
      };
    };

    desktop = {
      components = {
        avatar = {
          enable = true;
          users.asen = ../../assets/avatars/asen.jpg;
        };
        wallpaper = {
          enable = true;
          directory = ../../assets/wallpapers;
          initialStrategy = "random";
        };
      };
      enable = true;
      shell = {
        enable = true;
        backend = "dank-material-shell";
        compositor = "hyprland";
      };
      theme = {
        enable = true;
        image = ../../assets/wallpapers/a_woman_with_long_hair_wearing_sunglasses.png;
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
