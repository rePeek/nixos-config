{ ... }:
{
  imports = [
    ../../../modules/home-manager/common
    ../../../modules/home-manager/gui
    ../../../modules/home-manager/scripts/scripts.nix
    ../../../modules/home-manager/home.nix
    ../../../modules/home-manager/xdg-mimes.nix
    ../../../modules/home-manager/ghostty.nix
    ../../../modules/home-manager/openlist.nix
    ../../../modules/home-manager/rclone.nix
  ];

  programs.git.settings.user = {
    name = "rePeek";
    email = "senxlin@gmail.com";
  };
}
