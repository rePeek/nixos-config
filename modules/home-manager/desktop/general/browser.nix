# General browser defaults for the desktop profile.
{
  config,
  lib,
  ...
}:

let
  cfg = config.custom.desktop.defaults.browser;
  proxyCfg = cfg.proxy;

  mimeTypes = [
    "text/html"
    "x-scheme-handler/about"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/unknown"
  ];

  mimeDefaults = lib.genAttrs mimeTypes (_mimeType: [ "firefox.desktop" ]);

  userModule = {
    programs.firefox = {
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

    stylix.targets.firefox.enable = lib.mkDefault false;

    xdg.mimeApps = {
      associations.added = mimeDefaults;
      defaultApplications = mimeDefaults;
    };
  };
in
{
  options.custom.desktop.defaults.browser.proxy = {
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

  config = lib.mkIf config.custom.desktop.enable userModule;
}
