{ pkgs, ... }:
{
  networking.hostName = "brain-holder";

  imports = [
    ./hardware

    ./user.nix
    ./misc.nix
    ./network.nix

    ../../modules/nixos
    ../../modules/nixos/desktop
  ];

  custom = {
    boot.mode = "uefi";

    features = {
      audio.enable = true;
      bluetooth.enable = true;
      graphics = {
        enable = true;
        compat32.enable = true;
      };
      nvidia.compute.enable = true;
      nvidia.driver.enable = true;
      power.profile = "performance";
      virtualization = {
        docker = true;
        libvirtd = {
          enable = true;
          kvm.cpu = "intel";
        };
      };
      kernel.cachyos = {
        enable = true;
        package = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;
      };
    };

    desktop = {
      addons = {
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
      agenix.enable = true;
    };

    tools = {
      audio.enable = true;
      network.enable = true;
    };
  };
}
