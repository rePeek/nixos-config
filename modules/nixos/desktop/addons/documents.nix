# Document utilities addon with matching text, PDF, and archive defaults.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.custom.desktop.addons.documents;
  theme = config.custom.desktop.theme;
  desktopUsers = config.custom.desktop.users;
  textEditorStyleVariant = if theme.polarity == "either" then "follow" else theme.polarity;

  archiveMimeTypes = [
    "application/zip"
    "application/rar"
    "application/7z"
    "application/*tar"
  ];

  mimeDefaults = {
    "text/plain" = [ cfg.textDesktopFile ];
    "application/pdf" = [ cfg.pdfDesktopFile ];
  }
  // lib.genAttrs archiveMimeTypes (_mimeType: [ cfg.archiveDesktopFile ]);

  userModule = {
    home.packages = with pkgs; [
      evince
      file-roller
      gnome-text-editor
    ];

    dconf.settings."org/gnome/TextEditor" = {
      custom-font = lib.mkDefault "Maple Mono 15";
      highlight-current-line = true;
      indent-style = "space";
      restore-session = false;
      show-grid = false;
      show-line-numbers = true;
      show-right-margin = false;
      style-scheme = lib.mkDefault (if theme.enable then "stylix" else "Adwaita");
      style-variant = lib.mkDefault textEditorStyleVariant;
      tab-width = "uint32 4";
      use-system-font = lib.mkDefault false;
      wrap-text = false;
    };

    xdg.configFile."mimeapps.list".force = lib.mkDefault true;
    xdg.mimeApps = {
      enable = lib.mkDefault true;
      associations.added = mimeDefaults;
      defaultApplications = mimeDefaults;
    };
  };
in
{
  options.custom.desktop.addons.documents = {
    enable = lib.mkEnableOption "document utility addon" // {
      default = true;
    };

    textDesktopFile = lib.mkOption {
      type = lib.types.str;
      default = "org.gnome.TextEditor.desktop";
      description = "Desktop file used for plain text MIME associations.";
    };

    pdfDesktopFile = lib.mkOption {
      type = lib.types.str;
      default = "org.gnome.Evince.desktop";
      description = "Desktop file used for PDF MIME associations.";
    };

    archiveDesktopFile = lib.mkOption {
      type = lib.types.str;
      default = "org.gnome.FileRoller.desktop";
      description = "Desktop file used for archive MIME associations.";
    };

    manageUserDefaults = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Inject document utility defaults into desktop Home Manager users.";
    };
  };

  config = lib.mkIf (config.custom.desktop.enable && cfg.enable && cfg.manageUserDefaults) {
    home-manager.users = lib.genAttrs desktopUsers (_username: {
      imports = [ userModule ];
    });
  };
}
