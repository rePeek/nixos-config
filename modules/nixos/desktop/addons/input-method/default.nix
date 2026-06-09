{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.desktop.addons.fcitx5;
  desktopUsers = config.custom.desktop.users;
  fcitx5ChineseAddons = pkgs.qt6Packages.fcitx5-chinese-addons;
  # Chinese Addons metadata uses legacy icon names like fcitx-pinyin, while
  # the package installs namespaced files like org.fcitx.Fcitx5.fcitx-pinyin.
  fcitx5ChineseAddonIconLinks = pkgs.runCommand "fcitx5-chinese-addon-icon-links" { } ''
    icon_dir="${fcitx5ChineseAddons}/share/icons"

    for icon in "$icon_dir"/hicolor/*/apps/org.fcitx.Fcitx5.*; do
        [ -e "$icon" ] || continue

        rel_path="''${icon#"$icon_dir"/}"
        dir="$out/share/icons/$(dirname "$rel_path")"
        name="$(basename "$icon")"
        legacy_name="''${name#org.fcitx.Fcitx5.}"

        mkdir -p "$dir"
        ln -s "$icon" "$dir/$legacy_name"
    done
  '';
  fcitx5KeyboardIconLinks = pkgs.runCommand "fcitx5-keyboard-icon-links" { } ''
    icon_dir="$out/share/icons/hicolor/scalable/apps"
    mkdir -p "$icon_dir"

    ln -s ${pkgs.adwaita-icon-theme}/share/icons/Adwaita/scalable/devices/input-keyboard.svg \
      "$icon_dir/input-keyboard.svg"
    ln -s ${pkgs.adwaita-icon-theme}/share/icons/Adwaita/symbolic/devices/input-keyboard-symbolic.svg \
      "$icon_dir/input-keyboard-symbolic.svg"
  '';

  fcitx5UserModule = {
    home.sessionVariables = {
      GLFW_IM_MODULE = lib.mkDefault "ibus";
      QT_IM_MODULE = lib.mkDefault "fcitx";
      SDL_IM_MODULE = lib.mkDefault "fcitx";
      XMODIFIERS = lib.mkDefault "@im=fcitx";
    };

    home.packages = [
      fcitx5ChineseAddons
      fcitx5ChineseAddonIconLinks
      fcitx5KeyboardIconLinks
    ];

    i18n.inputMethod = {
      enable = lib.mkDefault true;
      type = lib.mkDefault "fcitx5";
      fcitx5 = {
        waylandFrontend = lib.mkDefault true;
        addons = [
          pkgs.qt6Packages.fcitx5-configtool
          fcitx5ChineseAddons
          pkgs.fcitx5-gtk
        ];
        settings = {
          inputMethod = {
            GroupOrder."0" = lib.mkDefault "Default";
            "Groups/0" = {
              Name = lib.mkDefault "Default";
              "Default Layout" = lib.mkDefault "us";
              DefaultIM = lib.mkDefault "shuangpin";
            };
            "Groups/0/Items/0" = {
              Name = lib.mkDefault "keyboard-us";
              Layout = lib.mkDefault null;
            };
            "Groups/0/Items/1" = {
              Name = lib.mkDefault "shuangpin";
              Layout = lib.mkDefault null;
            };
            "Groups/0/Items/2" = {
              Name = lib.mkDefault "pinyin";
              Layout = lib.mkDefault null;
            };
          };
          addons.pinyin.globalSection.ShuangpinProfile = lib.mkDefault "Xiaohe";
        };
      };
    };
  };
in
{
  options.custom.desktop.addons.fcitx5 = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the default fcitx5 input method profile for desktop users.";
    };

    manageUserDefaults = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Inject fcitx5 defaults into users managed by the system desktop profile.";
    };
  };

  config = lib.mkIf (config.custom.desktop.enable && cfg.enable) {
    home-manager.users = lib.mkIf cfg.manageUserDefaults (
      lib.genAttrs desktopUsers (_username: {
        imports = [ fcitx5UserModule ];
      })
    );
  };
}
