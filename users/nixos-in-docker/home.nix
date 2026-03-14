{ ... }:
{
  imports = [
    ../home-manager/common
  ];

  home.username = "root";
  home.homeDirectory = "/root";

  home.stateVersion = "25.11"; # Please read the comment before changing.
  programs.home-manager.enable = true;
}
