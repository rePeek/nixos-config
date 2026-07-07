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
          fcitx-erbi fcitx-fullwidth-active fcitx-fullwidth-inactive fcitx-pinyin \
          fcitx-punc-active fcitx-punc-inactive fcitx-remind-active fcitx-remind-inactive \
          fcitx-shuangpin fcitx-wbpy fcitx-wubi fcitx-ziranma
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
in
{
  config = lib.mkIf config.custom.desktop.enable {
    i18n.inputMethod = {
      enable = lib.mkDefault true;
      type = lib.mkDefault "fcitx5";
      fcitx5 = {
        waylandFrontend = lib.mkDefault true;
        addons = [
          pkgs.qt6Packages.fcitx5-configtool
          fcitx5ChineseAddons
          pkgs.fcitx5-gtk
          pkgs.qt6Packages.fcitx5-qt
        ];
      };
    };

    environment = {
      systemPackages = [
        fcitx5KeyboardIconLinks
      ];

      sessionVariables = {
        GLFW_IM_MODULE = lib.mkDefault "ibus";
        GTK_IM_MODULE = lib.mkDefault "fcitx";
        QT_IM_MODULE = lib.mkDefault "fcitx";
        SDL_IM_MODULE = lib.mkDefault "fcitx";
        XMODIFIERS = lib.mkDefault "@im=fcitx";
      };
    };
  };
}
