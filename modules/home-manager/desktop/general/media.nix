# General media application defaults for the desktop profile.
{
  config,
  lib,
  pkgs,
  ...
}:

let
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
    lib.genAttrs imageMimeTypes (_mimeType: [ "imv-dir.desktop" ])
    // lib.genAttrs audioMimeTypes (_mimeType: [ "mpv.desktop" ])
    // lib.genAttrs videoMimeTypes (_mimeType: [ "mpv.desktop" ]);
in
{
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
