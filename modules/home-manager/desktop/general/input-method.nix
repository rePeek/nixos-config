# General Fcitx5 user defaults for desktop sessions.
{
  config,
  lib,
  pkgs,
  ...
}:

let
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
  ];
in
{
  config = lib.mkIf config.custom.desktop.enable {
    home.packages = [ pkgs.qt6Packages.fcitx5-configtool ];

    home.sessionVariables = {
      GLFW_IM_MODULE = lib.mkDefault "ibus";
      QT_IM_MODULE = lib.mkDefault "fcitx";
      SDL_IM_MODULE = lib.mkDefault "fcitx";
      XMODIFIERS = lib.mkDefault "@im=fcitx";
    };

    xdg.configFile."fcitx5" = {
      force = true;
      source = lib.mkDefault fcitx5UserConfig;
    };
  };
}
