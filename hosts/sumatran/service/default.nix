{
  users.groups.media = { };
  users.users.media = {
    isSystemUser = true;
    group = "media";
  };

  systemd.tmpfiles.rules = [
    "d /srv/media 0750 media media -"
  ];

  imports = [
    ./jellyfin.nix
    ./komga.nix
    ./navidrome.nix
    ./openlist-mount.nix
  ];
}
