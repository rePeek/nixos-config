# Shared Home Manager profile for the asen user.
{
  home.file = {
    ".face".source = ../../../assets/avatars/asen.jpg;
    ".face.icon".source = ../../../assets/avatars/asen.jpg;
  };

  custom.desktop.defaults.wallpaper = {
    enable = true;
    directory = ../../../assets/wallpapers;
    initialStrategy = "random";
  };

  programs.git.settings.user = {
    name = "rePeek";
    email = "senxlin@gmail.com";
  };
}
