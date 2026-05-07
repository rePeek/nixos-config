{ inputs, ... }:
{
  imports = [
    ../../../modules/home-manager/common
    ../../../modules/home-manager/llm-agents-package.nix
  ];

  programs.git.settings.user = {
    name = "rePeek";
    email = "senxlin@gmail.com";
  };
}
