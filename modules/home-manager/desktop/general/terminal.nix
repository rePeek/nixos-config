# General Kitty terminal defaults for the desktop profile.
{
  config,
  lib,
  osConfig ? null,
  pkgs,
  ...
}:

let
  themeEnabled = osConfig != null && osConfig.custom.desktop.theme.enable;
in
{
  config = lib.mkIf config.custom.desktop.enable {
    home = {
      packages = [ pkgs.kitty ];
      sessionVariables.TERMINAL = lib.mkDefault "kitty";
    };

    programs.kitty = {
      enable = lib.mkDefault true;
    }
    // lib.optionalAttrs (!themeEnabled) {
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
