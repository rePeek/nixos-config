# General browser defaults for the desktop profile.
{
  lib,
  ...
}:

let
  mimeTypes = [
    "text/html"
    "x-scheme-handler/about"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/unknown"
  ];

  mimeDefaults = lib.genAttrs mimeTypes (_mimeType: [ "firefox.desktop" ]);
in
{
  config = {
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

      policies.ExtensionSettings = {
        "{fb25c100-22ce-4d5a-be7e-75f3d6f0fc13}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/kiss-translator/latest.xpi";
        };
      };
    };

    stylix.targets.firefox.enable = lib.mkDefault false;

    xdg.mimeApps = {
      associations.added = mimeDefaults;
      defaultApplications = mimeDefaults;
    };
  };
}
