{
  users.groups.media = { };
  users.users.media = {
    isSystemUser = true;
    group = "media";
  };

  imports = [
    ./jellyfin.nix
    ./komga.nix
    ./navidrome.nix
    ./openlist.nix
    ./rclone.nix
  ];
}
