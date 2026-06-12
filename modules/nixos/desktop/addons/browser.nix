# Browser addon with matching XDG MIME defaults.
{
  config,
  lib,
  ...
}:

let
  cfg = config.custom.desktop.addons.browser;
  desktopUsers = config.custom.desktop.users;

  mimeTypes = [
    "text/html"
    "x-scheme-handler/about"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/unknown"
  ];

  mimeDefaults = lib.genAttrs mimeTypes (_mimeType: [ cfg.desktopFile ]);

  userModule = {
    programs.firefox = lib.mkIf (cfg.package == "firefox") {
      enable = lib.mkDefault true;
      languagePacks = lib.mkDefault [ "zh-CN" ];
    };

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
in
{
  options.custom.desktop.addons.browser = {
    enable = lib.mkEnableOption "default browser addon" // {
      default = true;
    };

    package = lib.mkOption {
      type = lib.types.enum [ "firefox" ];
      default = "firefox";
      description = "Browser profile to enable for desktop users.";
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
      description = "Inject browser defaults into desktop Home Manager users.";
    };
  };

  config = lib.mkIf (config.custom.desktop.enable && cfg.enable && cfg.manageUserDefaults) {
    home-manager.users = lib.genAttrs desktopUsers (_username: {
      imports = [ userModule ];
    });
  };
}
