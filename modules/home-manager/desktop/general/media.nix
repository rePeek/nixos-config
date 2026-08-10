# General media application defaults for the desktop profile.
# mpv and qView are installed via Flatpak; webp-pixbuf-loader remains as nixpkgs.
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
    lib.genAttrs imageMimeTypes (_: [ "com.interversehq.qView.desktop" ])
    // lib.genAttrs audioMimeTypes (_: [ "io.mpv.Mpv.desktop" ])
    // lib.genAttrs videoMimeTypes (_: [ "io.mpv.Mpv.desktop" ]);
in
{
  config = {
    home.packages = with pkgs; [
      webp-pixbuf-loader
    ];

    xdg.mimeApps = {
      associations.added = mimeDefaults;
      defaultApplications = mimeDefaults;
    };
  };
}
