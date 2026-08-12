{
  users.users.navidrome.extraGroups = [ "media" ];

  systemd.tmpfiles.rules = [
    "d /srv/media/music 0750 media media -"
  ];

  services.navidrome = {
    enable = true;
    openFirewall = true;

    settings = {
      Address = "0.0.0.0";
      Port = 4533;
      MusicFolder = "/srv/media/music";
    };
  };
}
