{
  services.navidrome = {
    enable = true;
    openFirewall = true;

    settings = {
      Address = "0.0.0.0";
      Port = 4533;
      MusicFolder = "/mnt/rc115";
    };
  };

  systemd.services.navidrome = {
    after = [ "rclone115.service" ];
    wants = [ "rclone115.service" ];
    requires = [ "rclone115.service" ];
  };
}
