{ pkgs, ... }:
{
  imports = [
    ./gnome.nix
    ./gtk.nix
    ./hyprland
    ./rofi.nix
    ./swaylock.nix
    ./swaync
    ./swayosd.nix
    ./waybar
    ./waypaper.nix
    ./browser.nix
    ./nemo.nix
    ./discard.nix
    ./koodoReader.nix
    ./fcitx5
  ];
  home = {
    packages = with pkgs; [
      imv
      mpv
      libreoffice
      wechat-uos
      qbittorrent-enhanced
      # telegram-desktop is unused now，and i dont know why.
      # telegram-desktop
      scrot
      xfce.thunar
      webp-pixbuf-loader
    ];
  };
}
