# Fcitx5 system integration for desktop sessions.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.desktop.components.fcitx5;
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
  options.custom.desktop.components.fcitx5 = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the default fcitx5 input method profile for desktop users.";
    };

    manageUserDefaults = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Apply fcitx5 profile defaults in desktop Home Manager users.";
    };
  };

  config = lib.mkIf (config.custom.desktop.enable && cfg.enable) {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = [
          pkgs.qt6Packages.fcitx5-configtool
          fcitx5ChineseAddons
          pkgs.fcitx5-gtk
        ];
        settings = {
          globalOptions = {
            "Hotkey/TriggerKeys"."0" = "Control+space";
            Hotkey = {
              EnumerateWithTriggerKeys = true;
              EnumerateSkipFirst = false;
            };
          };
          inputMethod = {
            GroupOrder."0" = "Default";
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "us";
              DefaultIM = "keyboard-us";
            };
            "Groups/0/Items/0" = {
              Name = "keyboard-us";
              Layout = null;
            };
          };
        };
      };
    };

    environment = {
      systemPackages = [
        fcitx5KeyboardIconLinks
      ];

      sessionVariables = {
        GLFW_IM_MODULE = "ibus";
        QT_IM_MODULE = "fcitx";
        SDL_IM_MODULE = "fcitx";
        XMODIFIERS = "@im=fcitx";
      };
    };
  };
}
