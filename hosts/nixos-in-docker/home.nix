{ ... }:
{
  imports = [
    ../../modules/home-manager/common
    ../../modules/home-manager/llm-agents-package.nix
  ];

  home.username = "root";
  home.homeDirectory = "/root";

  home.stateVersion = "25.11"; # Please read the comment before changing.
  programs.home-manager.enable = true;

  programs.git.settings.user = {
    name = "rePeek";
    email = "wangsenyin@gmail.com";
  };
}
