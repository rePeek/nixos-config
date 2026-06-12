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

  custom = {
    boot.mode = "uefi";

    features = {
      audio.enable = true;
      bluetooth.enable = true;
      graphics.enable = true;
      kernel.cachyos = {
        enable = true;
        package = pkgs.cachyosKernels.linuxPackages-cachyos-server-lto;
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
