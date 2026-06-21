{ pkgs, ... }:
{
  networking.hostName = "brain-holder";

  imports = [
    ./hardware

    ./misc.nix
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
        "libvirtd"
        "docker"
      ];
    };

    home.users.asen = {
      extraPackages = with pkgs; [
        calibre
        discord
        koodo-reader
        qbittorrent-enhanced
        scrot
        thunar
        telegram-desktop
      ];

      desktop.hyprland.outputRules = [
        {
          output = "DP-3";
          mode = "2560x1440@239.99";
          position = "auto";
          scale = "1";
        }
      ];

      browser.proxy = {
        enable = true;
        httpProxy = "home-server:7890";
        sslProxy = "home-server:7890";
        socksProxy = "home-server:7890";
        passthrough = "localhost,127.0.0.1,::1,home-server,*.local";
      };
    };

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
      agenix.enable = true;
    };

    tools = {
      audio.enable = true;
      network.enable = true;
    };
  };
}
