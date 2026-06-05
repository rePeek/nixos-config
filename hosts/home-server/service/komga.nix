{
  services.komga = {
    enable = true;
    openFirewall = true;
    settings = { };
  };

  systemd.services.komga = {
    after = [ "rclone115.service" ];
    wants = [ "rclone115.service" ];
    requires = [ "rclone115.service" ];
  };
}
