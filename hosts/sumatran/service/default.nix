{
  users.groups.media = { };
  users.users.media = {
    isSystemUser = true;
    group = "media";
  };

  imports = [
    ./komga.nix
    ./navidrome.nix
    ./openlist-mount.nix
  ];
}
