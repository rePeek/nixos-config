{
  pkgs,
  ...
}:
{
  users.users.jellyfin.extraGroups = [ "media" ];

  systemd.tmpfiles.rules = [
    "d /srv/media/movie 0750 media media -"
  ];

  networking.firewall.allowedTCPPorts = [ 8096 ];

  services.jellyfin = {
    enable = true;
    logDir = "/var/lib/jellyfin/log";
    cacheDir = "/var/lib/jellyfin/cache";
    dataDir = "/var/lib/jellyfin/data";
    configDir = "/var/lib/jellyfin/config";
  };

  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];
}
