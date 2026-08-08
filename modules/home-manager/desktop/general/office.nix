# General office application defaults for the desktop profile.
{
  lib,
  pkgs,
  ...
}:

let
  mimeTypes = [
    "application/vnd.oasis.opendocument.text"
    "application/vnd.oasis.opendocument.spreadsheet"
    "application/vnd.oasis.opendocument.presentation"
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    "application/vnd.openxmlformats-officedocument.presentationml.presentation"
    "application/msword"
    "application/vnd.ms-excel"
    "application/vnd.ms-powerpoint"
    "application/rtf"
  ];

  mimeDefaults = lib.genAttrs mimeTypes (_mimeType: [ "libreoffice.desktop" ]);
in
{
  config = {
    home.packages = with pkgs; [
      libreoffice
    ];

    xdg.mimeApps = {
      associations.added = mimeDefaults;
      defaultApplications = mimeDefaults;
    };
  };
}
