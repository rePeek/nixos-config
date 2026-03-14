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
  ];
  home = {
    packages = with pkgs; [
      imv
      mpv
      libreoffice
      wechat-uos
      qbittorrent-enhanced
    ];
  };
}
