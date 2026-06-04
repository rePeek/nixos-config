{ ... }:
{
  networking.hostName = "brain-holder";

  imports = [
    ./hardware

    ./user.nix
    ./misc.nix
    ./network.nix

    ../../modules/nixos
  ];

  custom = {
    boot.mode = "uefi";

    features = {
      audio.enable = true;
      bluetooth.enable = true;
      cpu.intel.enable = true;
      firmware.enable = true;
      gpu.nvidia = {
        enable = true;
        profiles = [
          "display"
          "compute"
        ];
      };
      # CachyOS LTO currently fails while linking kernel modules with ld.lld.
      # kernel.cachyos = {
      #   enable = true;
      #   package = pkgs.cachyosKernels.linuxPackages-cachyos-lts-lto-x86_64-v3;
      # };
      storage.ssd.enable = true;
    };

    desktop = {
      bluetooth.enable = true;
      gaming.enable = true;
      network.enable = true;
    };

    service = {
      desktop.enable = true;
      fhs.enable = true;
      power.profile = "performance";
      virtualization = {
        docker = true;
        libvirtd = true;
      };
      agenix.enable = true;
    };

    tools = {
      audio.enable = true;
      network.enable = true;
    };
  };
}
