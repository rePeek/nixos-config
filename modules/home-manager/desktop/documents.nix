# Document utility user defaults for the desktop profile.
{
  config,
  lib,
  osConfig ? null,
  pkgs,
  ...
}:

let
  cfg = config.custom.desktop.defaults.documents;
  theme =
    if osConfig == null then
      {
        enable = false;
        polarity = "either";
      }
    else
      osConfig.custom.desktop.theme;
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

in
{
  options.custom.desktop.defaults.documents = {
    enable = lib.mkEnableOption "document utility defaults" // {
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
      description = "Apply document utility defaults for this desktop user.";
    };
  };

  config = lib.mkIf (config.custom.desktop.enable && cfg.enable && cfg.manageUserDefaults) {
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
}
