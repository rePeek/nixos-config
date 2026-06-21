# Office application user defaults for the desktop profile.
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
    enable = lib.mkEnableOption "office application defaults" // {
      default = true;
    };

    desktopFile = lib.mkOption {
      type = lib.types.str;
      default = "libreoffice.desktop";
      description = "Desktop file used for office document MIME associations.";
    };

    manageUserDefaults = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Apply office defaults for this desktop user.";
    };
  };

  config = lib.mkIf (config.custom.desktop.enable && cfg.enable && cfg.manageUserDefaults) {
    home.packages = with pkgs; [
      libreoffice
    ];

    xdg.configFile."mimeapps.list".force = lib.mkDefault true;
    xdg.mimeApps = {
      enable = lib.mkDefault true;
      associations.added = mimeDefaults;
      defaultApplications = mimeDefaults;
    };
  };
}
