{ pkgs, ... }:
{
  networking.hostName = "brain-holder";

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
      desktop.extra.enable = true;

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

    core = {
      kernel.cachyos = {
        enable = true;
        package = pkgs.cachyosKernels.linuxPackages-cachyos-latest-zen4;
      };
    };

    server = {
      fhs.enable = true;
      agenix.enable = true;

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
}
