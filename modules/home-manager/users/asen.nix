# Shared Home Manager profile for the asen user.
{
  imports = [
    ../common
  ];

  programs.git.settings.user = {
    name = "rePeek";
    email = "senxlin@gmail.com";
  };
}
