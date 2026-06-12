{
  pkgs,
  pkgsUnstable,
  ...
}:
{
  imports = [
    ../../../modules/home-manager/common
    ../../../modules/home-manager/desktop
    ../../../modules/home-manager/extraServices
    ../../../modules/home-manager/llm-agents-package.nix
  ];

  home.packages = with pkgs; [
    calibre
    discord
    koodo-reader
    qbittorrent-enhanced
    scrot
    xfce.thunar
    pkgsUnstable.telegram-desktop
  ];

  custom.desktop.hyprland.outputRules = [
    {
      output = "DP-3";
      mode = "2560x1440@239.99";
      position = "auto";
      scale = "1";
    }
  ];

  programs.git.settings.user = {
    name = "rePeek";
    email = "senxlin@gmail.com";
  };
}
