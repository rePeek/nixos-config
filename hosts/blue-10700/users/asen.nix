{ inputs, ... }:
{
  imports = [
    ../../../modules/home-manager/common
  ];

  programs.git.settings.user = {
    name = "rePeek";
    email = "senxlin@gmail.com";
  };
}
