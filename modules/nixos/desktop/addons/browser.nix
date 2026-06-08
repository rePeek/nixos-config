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
    programs.firefox.enable = lib.mkIf (cfg.package == "firefox") (lib.mkDefault true);

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
