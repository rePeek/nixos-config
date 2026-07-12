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
  networking.hostName = "brain-holder";

  imports = [
    ./hardware

    ./misc.nix
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
        package = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;
      };
    };

    server = {
      fhs.enable = true;
      agenix.enable = true;

      virtualization = {
        docker = true;
        libvirtd = {
          enable = true;
          kvm.cpu = "intel";
        };
      };
    };

    desktop = {
      nvidia.compute.enable = true;
      nvidia.driver.enable = true;
      gaming.enable = true;
    };

  };
}
