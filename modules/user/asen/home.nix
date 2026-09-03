# Shared Home Manager profile for the asen user.
{ pkgs, ... }:
{
  home.file = {
    ".face".source = ../../../assets/avatars/asen.jpg;
    ".face.icon".source = ../../../assets/avatars/asen.jpg;
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 604800;
    maxCacheTtl = 604800;
    defaultCacheTtlSsh = 604800;
    maxCacheTtlSsh = 604800;
    pinentry.package = pkgs.pinentry-curses;
  };

  programs.git.settings = {
    user = {
      name = "rePeek";
      email = "senxlin@gmail.com";
      signingKey = "F8D6A23D561E28EC2EB23E8FB8CF115BCA7F8C1A";
    };

    commit.gpgSign = true;
    gpg.format = "openpgp";

    merge.tool = "codediff";
    mergetool.codediff.cmd = "nvim \"$MERGED\" -c \"CodeDiff --exit-on-close merge $MERGED\"";

    diff.tool = "codediff";
    difftool.codediff.cmd = "nvim \"$LOCAL\" \"$REMOTE\" +\"CodeDiff --exit-on-close file $LOCAL $REMOTE\"";
  };
}
