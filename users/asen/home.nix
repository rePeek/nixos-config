{ ... }:
{
  imports = [
    ../home-manager
  ];

  programs.git.settings.user = {
    name = "rePeek";
    email = "senxlin@gmail.com";
  };
}
