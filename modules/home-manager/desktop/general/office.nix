# General office application defaults for the desktop profile.
# LibreOffice is installed via nixpkgs.
{
  lib,
  pkgs,
  ...
}:

let
  writerMimeTypes = [
    "application/vnd.oasis.opendocument.text"
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    "application/msword"
    "application/rtf"
  ];

  calcMimeTypes = [
    "application/vnd.oasis.opendocument.spreadsheet"
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    "application/vnd.ms-excel"
  ];

  impressMimeTypes = [
    "application/vnd.oasis.opendocument.presentation"
    "application/vnd.openxmlformats-officedocument.presentationml.presentation"
    "application/vnd.ms-powerpoint"
  ];

  mimeDefaults =
    lib.genAttrs writerMimeTypes (_: [ "writer.desktop" ])
    // lib.genAttrs calcMimeTypes (_: [ "calc.desktop" ])
    // lib.genAttrs impressMimeTypes (_: [ "impress.desktop" ]);
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
