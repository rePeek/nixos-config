{
  users.users.komga.extraGroups = [ "media" ];

  services.komga = {
    enable = true;
    openFirewall = true;
    settings.server.port = 25600;
  };

  systemd.services.komga = {
    after = [ "rclone115.service" ];
    wants = [ "rclone115.service" ];
    requires = [ "rclone115.service" ];
  };
}
