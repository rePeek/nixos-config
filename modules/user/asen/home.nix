# Shared Home Manager profile for the asen user.
{
  home.file = {
    ".face".source = ../../../assets/avatars/asen.jpg;
    ".face.icon".source = ../../../assets/avatars/asen.jpg;
  };

  programs.git.settings.user = {
    name = "rePeek";
    email = "senxlin@gmail.com";
  };
}
