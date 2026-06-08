# Office addon with matching document defaults.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.custom.desktop.addons.office;
  desktopUsers = config.custom.desktop.users;

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

  userModule = {
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
in
{
  options.custom.desktop.addons.office = {
    enable = lib.mkEnableOption "office application addon" // {
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
      description = "Inject office defaults into desktop Home Manager users.";
    };
  };

  config = lib.mkIf (config.custom.desktop.enable && cfg.enable && cfg.manageUserDefaults) {
    home-manager.users = lib.genAttrs desktopUsers (_username: {
      imports = [ userModule ];
    });
  };
}
