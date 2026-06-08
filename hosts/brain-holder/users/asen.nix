{
  pkgs,
  pkgsUnstable,
  ...
}:
{
  imports = [
    ../../../modules/home-manager/common
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

  programs.git.settings.user = {
    name = "rePeek";
    email = "senxlin@gmail.com";
  };
}
