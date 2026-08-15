# Shared Home Manager profile for the asen user.
{
  home.file = {
    ".face".source = ../../../assets/avatars/asen.jpg;
    ".face.icon".source = ../../../assets/avatars/asen.jpg;
  };

  programs.git.settings = {
    user = {
      name = "rePeek";
      email = "senxlin@gmail.com";
      signingKey = "F8D6A23D561E28EC2EB23E8FB8CF115BCA7F8C1A";
    };

    commit.gpgSign = true;
    gpg.format = "openpgp";
  };
}
