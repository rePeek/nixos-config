# General browser defaults for the desktop profile.
{
  config,
  lib,
  osConfig ? null,
  ...
}:

let
  hostUserBrowserCfg =
    if osConfig == null then
      null
    else
      lib.attrByPath [
        "custom"
        "home"
        "users"
        config.home.username
        "browser"
      ] null osConfig;
  osCfg =
    if osConfig == null then
      {
        enable = true;
        package = "firefox";
        desktopFile = "firefox.desktop";
        firefoxProfileNames = [ ];
        manageUserDefaults = true;
        proxy = {
          enable = false;
          httpProxy = "";
          sslProxy = "";
          socksProxy = "";
          socksVersion = 5;
          passthrough = "localhost,127.0.0.1,::1";
        };
      }
    else if hostUserBrowserCfg != null then
      {
        enable = true;
        package = "firefox";
        desktopFile = "firefox.desktop";
        firefoxProfileNames = [ ];
        manageUserDefaults = true;
        proxy = hostUserBrowserCfg.proxy;
      }
    else
      {
        enable = true;
        package = "firefox";
        desktopFile = "firefox.desktop";
        firefoxProfileNames = [ ];
        manageUserDefaults = true;
        proxy = {
          enable = false;
          httpProxy = "";
          sslProxy = "";
          socksProxy = "";
          socksVersion = 5;
          passthrough = "localhost,127.0.0.1,::1";
        };
      };
  cfg = config.custom.desktop.defaults.browser;
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

      profiles.default = {
        isDefault = true;
        path = "default";

        settings = {
          # 浏览器语言：简体中文
          "intl.locale.requested" = "zh-CN";

          # 禁用 Firefox 数据收集与使用
          "datareporting.healthreport.uploadEnabled" = false;
          "browser.discovery.enabled" = false;
          "app.shield.optoutstudies.enabled" = false;
          "nimbus.rollouts.enabled" = false;
          "datareporting.usage.uploadEnabled" = false;
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

          # 浏览器布局：垂直标签页
          "sidebar.revamp" = true;
          "sidebar.verticalTabs" = true;

          # 禁用浏览时的推荐
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;

          # 在搜索结果页面的地址栏中显示搜索词
          "browser.urlbar.showSearchTerms.enabled" = true;
        };

        search = {
          default = "ddg";
          force = true;
        };
      };

      policies = lib.mkMerge [
        {
          ExtensionSettings = {
            "{fb25c100-22ce-4d5a-be7e-75f3d6f0fc13}" = {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/kiss-translator/latest.xpi";
            };
          };
        }
        (lib.mkIf proxyCfg.enable {
          Proxy = {
            Mode = "manual";
            HTTPProxy = proxyCfg.httpProxy;
            SSLProxy = proxyCfg.sslProxy;
            SOCKSProxy = proxyCfg.socksProxy;
            SOCKSVersion = proxyCfg.socksVersion;
            Passthrough = proxyCfg.passthrough;
          };
        })
      ];
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
  options.custom.desktop.defaults.browser = {
    enable = lib.mkEnableOption "default browser addon" // {
      default = osCfg.enable;
    };

    package = lib.mkOption {
      type = lib.types.enum [ "firefox" ];
      default = osCfg.package;
      description = "Browser profile to enable for desktop users.";
    };

    desktopFile = lib.mkOption {
      type = lib.types.str;
      default = osCfg.desktopFile;
      description = "Desktop file used for browser MIME associations.";
    };

    firefoxProfileNames = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = osCfg.firefoxProfileNames;
      description = "Firefox profile names that Stylix should theme. Leave empty when Firefox profiles are not managed declaratively.";
      example = [ "default" ];
    };

    manageUserDefaults = lib.mkOption {
      type = lib.types.bool;
      default = osCfg.manageUserDefaults;
      description = "Apply browser defaults for this desktop user.";
    };

    proxy = {
      enable = lib.mkEnableOption "Firefox proxy policy" // {
        default = osCfg.proxy.enable;
      };

      httpProxy = lib.mkOption {
        type = lib.types.str;
        default = osCfg.proxy.httpProxy;
        description = "Firefox HTTP proxy in host:port form.";
        example = "home-server:7890";
      };

      sslProxy = lib.mkOption {
        type = lib.types.str;
        default = osCfg.proxy.sslProxy;
        description = "Firefox HTTPS proxy in host:port form.";
        example = "home-server:7890";
      };

      socksProxy = lib.mkOption {
        type = lib.types.str;
        default = osCfg.proxy.socksProxy;
        description = "Firefox SOCKS proxy in host:port form.";
        example = "home-server:7890";
      };

      socksVersion = lib.mkOption {
        type = lib.types.enum [
          4
          5
        ];
        default = osCfg.proxy.socksVersion;
        description = "Firefox SOCKS proxy protocol version.";
      };

      passthrough = lib.mkOption {
        type = lib.types.str;
        default = osCfg.proxy.passthrough;
        description = "Comma-separated Firefox proxy bypass list.";
      };
    };
  };

  config = lib.mkIf (config.custom.desktop.enable && cfg.enable && cfg.manageUserDefaults) userModule;
}
