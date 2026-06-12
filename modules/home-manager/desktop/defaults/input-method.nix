# Fcitx5 user profile defaults for desktop sessions.
{
  config,
  lib,
  osConfig ? null,
  pkgs,
  ...
}:

let
  desktop =
    if osConfig == null then
      {
        enable = false;
        components = { };
      }
    else
      osConfig.custom.desktop;
  cfg =
    desktop.components.fcitx5 or {
      enable = false;
      manageUserDefaults = false;
    };

  fcitx5Settings = config.i18n.inputMethod.fcitx5.settings;
  fcitx5Themes = config.i18n.inputMethod.fcitx5.themes;
  stylixTheme = fcitx5Themes.stylix or null;

  fcitx5UserConfig = pkgs.linkFarm "fcitx5-user-config" [
    {
      name = "profile";
      path = pkgs.writeText "fcitx5-profile" ''
        [GroupOrder]
        0=Default

        [Groups/0]
        Default Layout=us
        DefaultIM=shuangpin
        Name=Default

        [Groups/0/Items/0]
        Layout=null
        Name=keyboard-us

        [Groups/0/Items/1]
        Layout=null
        Name=shuangpin

        [Groups/0/Items/2]
        Layout=null
        Name=pinyin
      '';
    }
    {
      name = "conf/pinyin.conf";
      path = pkgs.writeText "fcitx5-conf-pinyin.conf" ''
        ShuangpinProfile=Xiaohe
      '';
    }
    {
      name = "conf/classicui.conf";
      path = pkgs.writeText "fcitx5-conf-classicui.conf" (
        lib.generators.toINIWithGlobalSection { } fcitx5Settings.addons.classicui
      );
    }
  ];
in
{
  config = lib.mkIf (desktop.enable && cfg.enable && cfg.manageUserDefaults) {
    xdg.configFile."fcitx5" = {
      force = true;
      source = lib.mkDefault fcitx5UserConfig;
    };

    xdg.dataFile = lib.mkIf (stylixTheme != null) {
      "fcitx5/themes/stylix/theme.conf" = {
        force = true;
        text = lib.generators.toINI { } stylixTheme.theme;
      };
      "fcitx5/themes/stylix/highlight.svg" = {
        force = true;
        source = stylixTheme.highlightImage;
      };
      "fcitx5/themes/stylix/panel.svg" = {
        force = true;
        source = stylixTheme.panelImage;
      };
    };
  };
}
