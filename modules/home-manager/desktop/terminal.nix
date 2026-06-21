# Terminal user defaults for the desktop profile.
{
  config,
  lib,
  osConfig ? null,
  pkgs,
  ...
}:

let
  osCfg =
    if osConfig == null then
      {
        enable = true;
        manageUserDefaults = true;
        package = "kitty";
        command = "kitty";
        desktopFile = "kitty.desktop";
      }
    else
      osConfig.custom.desktop.components.terminal;
  cfg = config.custom.desktop.defaults.terminal;
  theme =
    if osConfig == null then
      {
        enable = false;
      }
    else
      osConfig.custom.desktop.theme;

  mimeDefaults = {
    terminal = [ cfg.desktopFile ];
  };

in
{
  options.custom.desktop.defaults.terminal = {
    enable = lib.mkEnableOption "terminal defaults" // {
      default = osCfg.enable;
    };

    package = lib.mkOption {
      type = lib.types.enum [ "kitty" ];
      default = osCfg.package;
      description = "Terminal profile to enable for this user.";
    };

    command = lib.mkOption {
      type = lib.types.str;
      default = osCfg.command;
      description = "Terminal command used by desktop shell key bindings.";
    };

    desktopFile = lib.mkOption {
      type = lib.types.str;
      default = osCfg.desktopFile;
      description = "Desktop file used by terminal picker defaults.";
    };

    manageUserDefaults = lib.mkOption {
      type = lib.types.bool;
      default = osCfg.manageUserDefaults;
      description = "Apply terminal defaults for this desktop user.";
    };
  };

  config = lib.mkIf (config.custom.desktop.enable && cfg.enable && cfg.manageUserDefaults) {
    home.sessionVariables.TERMINAL = lib.mkDefault cfg.command;

    home.packages = lib.mkIf (cfg.package == "kitty") [
      pkgs.kitty
    ];

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
