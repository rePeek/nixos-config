# NixOS configuration for amur.
{ pkgs, ... }:
let
  telegramDesktopX11 = pkgs.symlinkJoin {
    name = "telegram-desktop-x11";
    paths = [ pkgs.telegram-desktop ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram "$out/bin/Telegram" \
        --set QT_QPA_PLATFORM xcb \
        --set QT_IM_MODULE fcitx \
        --set XMODIFIERS '@im=fcitx'
    '';
  };
in
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
        calibre
        discord
        koodo-reader
        qbittorrent-enhanced
        scrot
        thunar
        telegramDesktopX11
      ];

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
      amd.enable = true;
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
