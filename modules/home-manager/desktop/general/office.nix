# General office application defaults for the desktop profile.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.custom.desktop.defaults.office;

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

  mimeDefaults = lib.genAttrs mimeTypes (_mimeType: [ cfg.desktopFile ]);

in
{
  options.custom.desktop.defaults.office = {
    desktopFile = lib.mkOption {
      type = lib.types.str;
      default = "libreoffice.desktop";
      description = "Desktop file used for office document MIME associations.";
    };

  };

  config = lib.mkIf config.custom.desktop.enable {
    home.packages = with pkgs; [
      libreoffice
    ];

    xdg.mimeApps = {
      associations.added = mimeDefaults;
      defaultApplications = mimeDefaults;
    };
  };
}
