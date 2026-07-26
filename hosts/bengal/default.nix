{
  pkgs,
  ...
}:

{
  networking.hostName = "bengal";

  imports = [
    ./hardware
    ./network.nix

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

    core = {
      kernel.cachyos = {
        enable = true;
        package = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;
      };
    };

    server = {
      agenix.enable = true;
      fhs.enable = true;
      mihomo.enable = true;
      cpa.enable = true;
      virtualization = {
        docker = true;
        qemuUserAarch64 = true;
      };
    };
  };

  security.sudo.wheelNeedsPassword = false;
}
