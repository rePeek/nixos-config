{ ... }:
{
  imports = [
    ../../../modules/home-manager/common
    ../../../modules/home-manager/xdg-mimes.nix
    ../../../modules/home-manager/extraServices
    ../../../modules/home-manager/llm-agents-package.nix
  ];

  programs.git.settings.user = {
    name = "rePeek";
    email = "senxlin@gmail.com";
  };
}
