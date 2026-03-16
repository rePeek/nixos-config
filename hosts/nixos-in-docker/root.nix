{ ... }:
{
  imports = [
    ../../modules/home-manager/common
    ../../modules/home-manager/llm-agents-package.nix
  ];

  home.username = "root";
  home.homeDirectory = "/root";
  
  programs.git.settings.user = {
    name = "rePeek";
    email = "wangsenyin@gmail.com";
  };
}
