# Browser user defaults for the desktop profile.
{
  config,
  lib,
  osConfig ? null,
  ...
}:

let
  cfg = config.custom.desktop.defaults.browser;
  desktopEnabled = osConfig == null || osConfig.custom.desktop.enable;

  mimeTypes = [
    "text/html"
    "x-scheme-handler/about"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/unknown"
  ];

  mimeDefaults = lib.genAttrs mimeTypes (_mimeType: [ cfg.desktopFile ]);
in
{
  options.custom.desktop.defaults.browser = {
    enable = lib.mkEnableOption "browser defaults" // {
      default = true;
    };

    package = lib.mkOption {
      type = lib.types.enum [ "firefox" ];
      default = "firefox";
      description = "Browser profile to enable for this user.";
    };

    desktopFile = lib.mkOption {
      type = lib.types.str;
      default = "firefox.desktop";
      description = "Desktop file used for browser MIME associations.";
    };

    firefoxProfileNames = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Firefox profile names that Stylix should theme. Leave empty when Firefox profiles are not managed declaratively.";
      example = [ "default" ];
    };

    manageUserDefaults = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Apply browser defaults for this desktop user.";
    };
  };

  config = lib.mkIf (desktopEnabled && cfg.enable && cfg.manageUserDefaults) {
    programs.firefox.enable = lib.mkIf (cfg.package == "firefox") (lib.mkDefault true);

    stylix.targets.firefox = lib.mkIf (cfg.package == "firefox") (
      if cfg.firefoxProfileNames == [ ] then
        {
          enable = lib.mkDefault false;
        }
      else
        {
          profileNames = cfg.firefoxProfileNames;
        }
    );

    xdg.configFile."mimeapps.list".force = lib.mkDefault true;
    xdg.mimeApps = {
      enable = lib.mkDefault true;
      associations.added = mimeDefaults;
      defaultApplications = mimeDefaults;
    };
  };
}
