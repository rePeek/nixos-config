# General document utility defaults for the desktop profile.
# Apps (Evince, File Roller, GNOME Text Editor) are installed via Flatpak.
{
  config,
  lib,
  ...
}:

let
  stylixColors = lib.attrByPath [ "lib" "stylix" "colors" "withHashtag" ] null config;
  stylixEnabled = stylixColors != null;

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
  config = {
    dconf.settings."org/gnome/TextEditor" = {
      custom-font = lib.mkDefault "Maple Mono 15";
      highlight-current-line = true;
      indent-style = "space";
      restore-session = false;
      show-grid = false;
      show-line-numbers = true;
      show-right-margin = false;
      style-scheme = lib.mkDefault (if stylixEnabled then "stylix" else "Adwaita");
      style-variant = lib.mkDefault (if stylixEnabled then config.stylix.polarity else "follow");
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
