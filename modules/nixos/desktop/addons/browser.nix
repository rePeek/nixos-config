# Browser addon with matching XDG MIME defaults.
{
  config,
  lib,
  ...
}:

let
  cfg = config.custom.desktop.addons.browser;
  desktopUsers = config.custom.desktop.users;
  proxyCfg = cfg.proxy;

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
      configPath = lib.mkDefault ".mozilla/firefox";
      languagePacks = lib.mkDefault [ "zh-CN" ];
      policies = lib.mkIf proxyCfg.enable {
        Proxy = {
          Mode = "manual";
          HTTPProxy = proxyCfg.httpProxy;
          SSLProxy = proxyCfg.sslProxy;
          SOCKSProxy = proxyCfg.socksProxy;
          SOCKSVersion = proxyCfg.socksVersion;
          Passthrough = proxyCfg.passthrough;
        };
      };
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

    proxy = {
      enable = lib.mkEnableOption "Firefox proxy policy";

      httpProxy = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Firefox HTTP proxy in host:port form.";
        example = "home-server:7890";
      };

      sslProxy = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Firefox HTTPS proxy in host:port form.";
        example = "home-server:7890";
      };

      socksProxy = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Firefox SOCKS proxy in host:port form.";
        example = "home-server:7890";
      };

      socksVersion = lib.mkOption {
        type = lib.types.enum [
          4
          5
        ];
        default = 5;
        description = "Firefox SOCKS proxy protocol version.";
      };

      passthrough = lib.mkOption {
        type = lib.types.str;
        default = "localhost,127.0.0.1,::1";
        description = "Comma-separated Firefox proxy bypass list.";
      };
    };
  };

  config = lib.mkIf (config.custom.desktop.enable && cfg.enable && cfg.manageUserDefaults) {
    home-manager.users = lib.genAttrs desktopUsers (_username: {
      imports = [ userModule ];
    });
  };
}
