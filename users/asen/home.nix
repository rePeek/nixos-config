{ ... }: {
  imports = [
    ../home-manager
  ];

  programs.git.settings.user = {
    name = "asen";
    email = "senxlin@gmail.com";
  };
}
