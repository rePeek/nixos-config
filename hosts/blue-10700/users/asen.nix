{ inputs, ... }:
{
  imports = [
    ../../../modules/home-manager/common
    ../../../modules/home-manager/desktop
    ../../../modules/home-manager/llm-agents-package.nix
  ];

  custom.desktop.hyprland.outputRules = [
    {
      output = "DP-1";
      mode = "preferred";
      position = "auto";
      scale = "1.25";
      transform = 2;
    }
  ];

  programs.git.settings.user = {
    name = "rePeek";
    email = "senxlin@gmail.com";
  };
}
