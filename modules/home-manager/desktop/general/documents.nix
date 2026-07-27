# General document utility defaults for the desktop profile.
{
  config,
  lib,
  osConfig ? null,
  pkgs,
  ...
}:

let
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
    "text/plain" = [ "org.gnome.TextEditor.desktop" ];
    "application/pdf" = [ "org.gnome.Evince.desktop" ];
  }
  // lib.genAttrs archiveMimeTypes (_mimeType: [ "org.gnome.FileRoller.desktop" ]);
in
{
  config = lib.mkIf config.custom.desktop.enable {
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

    xdg.mimeApps = {
      associations.added = mimeDefaults;
      defaultApplications = mimeDefaults;
    };
  };
}
