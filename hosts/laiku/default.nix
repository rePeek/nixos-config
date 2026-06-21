# Desktop profile for the Lecoo MINI PRO-AHP host.
{ pkgs, ... }:

{
  networking.hostName = "laiku";

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
      asen.extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };

    features = {
      amd.enable = true;
      audio.enable = true;
      bluetooth.enable = true;
      graphics = {
        enable = true;
        compat32.enable = true;
      };
      kernel.cachyos = {
        enable = true;
        package = pkgs.cachyosKernels.linuxPackages-cachyos-latest-zen4;
      };
      power.profile = "performance";
    };

    desktop = {
      components = {
        avatar = {
          enable = true;
          users.asen = ../../assets/avatars/asen.jpg;
        };
        gaming.enable = true;
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
      fhs.enable = true;
      tailscale.enable = true;
    };

    tools = {
      audio.enable = true;
      network.enable = true;
    };
  };

  security.sudo.wheelNeedsPassword = false;
}
