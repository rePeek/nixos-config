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
  terminalCommand = "kitty";
  terminalDesktopFile = "kitty.desktop";
in
{
  config = lib.mkIf config.custom.desktop.enable {
    home = {
      packages = [ pkgs.kitty ];
      sessionVariables.TERMINAL = lib.mkDefault terminalCommand;
    };

    programs.kitty = {
      enable = lib.mkDefault true;
      package = lib.mkDefault null;
    }
    // lib.optionalAttrs (!themeEnabled) {
      themeFile = lib.mkDefault "GitHub_Light";
    };

    xdg.configFile."xdg-terminals.list".text = lib.mkDefault ''
      ${terminalDesktopFile}
    '';

    xdg.mimeApps = {
      associations.added.terminal = [ terminalDesktopFile ];
      defaultApplications.terminal = [ terminalDesktopFile ];
    };
  };
}
