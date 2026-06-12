# Media application user defaults for the desktop profile.
{
  config,
  lib,
  osConfig ? null,
  pkgs,
  ...
}:

let
  cfg = config.custom.desktop.defaults.media;
  desktopEnabled = osConfig == null || osConfig.custom.desktop.enable;

  imageMimeTypes = [
    "image/bmp"
    "image/gif"
    "image/jpeg"
    "image/jpg"
    "image/png"
    "image/svg+xml"
    "image/tiff"
    "image/vnd.microsoft.icon"
    "image/webp"
  ];

  audioMimeTypes = [
    "audio/aac"
    "audio/mpeg"
    "audio/ogg"
    "audio/opus"
    "audio/wav"
    "audio/webm"
    "audio/x-matroska"
  ];

  videoMimeTypes = [
    "video/mp2t"
    "video/mp4"
    "video/mpeg"
    "video/ogg"
    "video/webm"
    "video/x-flv"
    "video/x-matroska"
    "video/x-msvideo"
  ];

  mimeDefaults =
    lib.genAttrs imageMimeTypes (_mimeType: [ cfg.imageDesktopFile ])
    // lib.genAttrs audioMimeTypes (_mimeType: [ cfg.mediaDesktopFile ])
    // lib.genAttrs videoMimeTypes (_mimeType: [ cfg.mediaDesktopFile ]);
in
{
  options.custom.desktop.defaults.media = {
    enable = lib.mkEnableOption "media application default" // {
      default = true;
    };

    imageDesktopFile = lib.mkOption {
      type = lib.types.str;
      default = "imv-dir.desktop";
      description = "Desktop file used for image MIME associations.";
    };

    mediaDesktopFile = lib.mkOption {
      type = lib.types.str;
      default = "mpv.desktop";
      description = "Desktop file used for audio and video MIME associations.";
    };

    manageUserDefaults = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Apply media defaults for this desktop user.";
    };
  };

  config = lib.mkIf (desktopEnabled && cfg.enable && cfg.manageUserDefaults) {
    home.packages = with pkgs; [
      imv
      mpv
      webp-pixbuf-loader
    ];

    xdg.configFile."mimeapps.list".force = lib.mkDefault true;
    xdg.mimeApps = {
      enable = lib.mkDefault true;
      associations.added = mimeDefaults;
      defaultApplications = mimeDefaults;
    };
  };
}
