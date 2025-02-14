{ pkgs, ... }:{
  services.jellyfin = {
    enable = true;
    user = "asen";
    logDir = "/mnt/public_data/service/jellyfin/logDir";
    cacheDir = "/mnt/public_data/service/jellyfin/cacheDir";
    dataDir = "/mnt/public_data/service/jellyfin/dataDir";
    configDir = "/mnt/public_data/service/jellyfin/configDir";
  };


  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];
}
