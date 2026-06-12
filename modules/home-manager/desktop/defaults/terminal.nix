# Terminal user defaults for the desktop profile.
{
  lib,
  osConfig ? null,
  ...
}:

let
  desktop =
    if osConfig == null then
      {
        enable = false;
        components = { };
        theme.enable = false;
      }
    else
      osConfig.custom.desktop;
  cfg =
    desktop.components.terminal or {
      enable = false;
      manageUserDefaults = false;
      package = "kitty";
      command = "kitty";
      desktopFile = "kitty.desktop";
    };
  theme = desktop.theme;

  mimeDefaults = {
    terminal = [ cfg.desktopFile ];
  };
in
{
  config = lib.mkIf (desktop.enable && cfg.enable && cfg.manageUserDefaults) {
    home.sessionVariables.TERMINAL = lib.mkDefault cfg.command;

    programs.kitty = lib.mkIf (cfg.package == "kitty") (
      {
        enable = lib.mkDefault true;
        package = lib.mkDefault null;
      }
      // lib.optionalAttrs (!theme.enable) {
        themeFile = lib.mkDefault "GitHub_Light";
      }
    );

    xdg.configFile."xdg-terminals.list".text = lib.mkDefault ''
      ${cfg.desktopFile}
    '';

    xdg.mimeApps = {
      enable = lib.mkDefault true;
      associations.added = mimeDefaults;
      defaultApplications = mimeDefaults;
    };
  };
}
