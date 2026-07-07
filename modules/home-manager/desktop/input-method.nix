# Fcitx5 user profile defaults for desktop sessions.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  fcitx5ChineseAddons = pkgs.qt6Packages.fcitx5-chinese-addons.overrideAttrs (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
      papirus_icons="${pkgs.papirus-icon-theme}/share/icons/Papirus"

      for size in 16x16 22x22 24x24; do
        icon_dir="$out/share/icons/hicolor/$size/apps"
        for icon in \
          fcitx-cangjie fcitx-chn fcitx-chttrans-active fcitx-chttrans-inactive \
          fcitx-erbi fcitx-fullwidth-active fcitx-fullwidth-inactive \
          fcitx-pinyin fcitx-punc-active fcitx-punc-inactive \
          fcitx-remind-active fcitx-remind-inactive fcitx-shuangpin \
          fcitx-wbpy fcitx-wubi fcitx-ziranma
        do
          source_icon="$icon"
          [ "$icon" = "fcitx-wbpy" ] && source_icon="fcitx-wubi"

          rm -f "$icon_dir/org.fcitx.Fcitx5.$icon.png" "$icon_dir/$icon.png"
          ln -sf "$papirus_icons/$size/actions/$source_icon.svg" "$icon_dir/org.fcitx.Fcitx5.$icon.svg"
          ln -sf "org.fcitx.Fcitx5.$icon.svg" "$icon_dir/$icon.svg"
        done
      done

      find "$out/share/icons/hicolor" -name '*.png' -delete
    '';
  });

  fcitx5KeyboardIconLinks = pkgs.runCommand "fcitx5-keyboard-icon-links" { } ''
    icon_dir="$out/share/icons/hicolor/scalable/apps"
    mkdir -p "$icon_dir"

    ln -s ${pkgs.adwaita-icon-theme}/share/icons/Adwaita/scalable/devices/input-keyboard.svg \
      "$icon_dir/input-keyboard.svg"
    ln -s ${pkgs.adwaita-icon-theme}/share/icons/Adwaita/symbolic/devices/input-keyboard-symbolic.svg \
      "$icon_dir/input-keyboard-symbolic.svg"
  '';

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
    home.sessionVariables = {
      GLFW_IM_MODULE = lib.mkDefault "ibus";
      GTK_IM_MODULE = lib.mkDefault "fcitx";
      QT_IM_MODULE = lib.mkDefault "fcitx";
      SDL_IM_MODULE = lib.mkDefault "fcitx";
      XMODIFIERS = lib.mkDefault "@im=fcitx";
    };

    home.packages = [
      fcitx5ChineseAddons
      fcitx5KeyboardIconLinks
      pkgs.qt6Packages.fcitx5-qt
    ];

    xdg.configFile."fcitx5" = {
      force = true;
      source = lib.mkDefault fcitx5UserConfig;
    };
  };
}
