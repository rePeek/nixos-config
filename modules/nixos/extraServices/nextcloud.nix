{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.custom.service.nextcloud;
in
{
  options.custom.service.nextcloud.enable = lib.mkEnableOption "Nextcloud service";

  config = lib.mkIf cfg.enable {
    environment.etc."nextcloud-admin-pass".text = "112358";
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud32;
      hostName = "Hcloud";
      home = "/mnt/public_data/service/nextcloud32";
      config.dbtype = "sqlite";
      https = false;

      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps)
          onlyoffice
          ;
      };
      extraAppsEnable = true;
      autoUpdateApps.enable = true;

      config = {
        adminuser = "asen";
        adminpassFile = "/etc/nextcloud-admin-pass";
      };

      settings = {
        allow_local_remote_servers = true;
        enabledPreviewProviders = [
          "OC\\Preview\\BMP"
          "OC\\Preview\\GIF"
          "OC\\Preview\\JPEG"
          "OC\\Preview\\Krita"
          "OC\\Preview\\MarkDown"
          "OC\\Preview\\MP3"
          "OC\\Preview\\OpenDocument"
          "OC\\Preview\\PNG"
          "OC\\Preview\\TXT"
          "OC\\Preview\\XBitmap"
          "OC\\Preview\\HEIC"
        ];
        trusted_domains = [ "192.168.0.112" ];
      };
    };
  };
}
