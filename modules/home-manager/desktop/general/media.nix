# General media application defaults for the desktop profile.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.custom.desktop.defaults.media;

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

  };

  config = lib.mkIf config.custom.desktop.enable {
    home.packages = with pkgs; [
      imv
      mpv
      webp-pixbuf-loader
    ];

    xdg.mimeApps = {
      associations.added = mimeDefaults;
      defaultApplications = mimeDefaults;
    };
  };
}
