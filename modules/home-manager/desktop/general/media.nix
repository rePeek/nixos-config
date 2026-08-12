# General media application defaults for the desktop profile.
# imv and mpv are installed via nixpkgs.
{
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
    lib.genAttrs imageMimeTypes (_: [ "imv-dir.desktop" ])
    // lib.genAttrs audioMimeTypes (_: [ "mpv.desktop" ])
    // lib.genAttrs videoMimeTypes (_: [ "mpv.desktop" ]);
in
{
  config = {
    home.packages = with pkgs; [
      mpv
      imv
      webp-pixbuf-loader
    ];

    xdg.mimeApps = {
      associations.added = mimeDefaults;
      defaultApplications = mimeDefaults;
    };
  };
}
