# General Kitty terminal defaults for the desktop profile.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  stylixColors = lib.attrByPath [ "lib" "stylix" "colors" "withHashtag" ] null config;
  stylixEnabled = stylixColors != null;
in
{
  config = {
    home = {
      packages = [ pkgs.kitty ];
      sessionVariables.TERMINAL = lib.mkDefault "kitty";
    };

    programs.kitty = {
      enable = lib.mkDefault true;
    }
    // lib.optionalAttrs (!stylixEnabled) {
      themeFile = lib.mkDefault "GitHub_Light";
    };

    xdg.configFile."xdg-terminals.list".text = lib.mkDefault ''
      kitty.desktop
    '';

    xdg.mimeApps = {
      associations.added.terminal = [ "kitty.desktop" ];
      defaultApplications.terminal = [ "kitty.desktop" ];
    };
  };
}
