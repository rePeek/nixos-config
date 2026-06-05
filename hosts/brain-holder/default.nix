{ ... }:
{
  networking.hostName = "brain-holder";

  imports = [
    ./hardware

    ./user.nix
    ./misc.nix
    ./network.nix
    ./service

    ../../modules/nixos
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
      # CachyOS LTO currently fails while linking kernel modules with ld.lld.
      # kernel.cachyos = {
      #   enable = true;
      #   package = pkgs.cachyosKernels.linuxPackages-cachyos-lts-lto-x86_64-v3;
      # };
    };

    desktop = {
      bluetooth.enable = true;
      gaming.enable = true;
      network.enable = true;
    };

    service = {
      desktop.enable = true;
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
