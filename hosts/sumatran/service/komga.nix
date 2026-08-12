{
  users.users.komga.extraGroups = [ "media" ];

  systemd.tmpfiles.rules = [
    "d /srv/media/comic 0750 media media -"
  ];

  services.komga = {
    enable = true;
    openFirewall = true;
    settings.server.port = 25600;
  };
}
