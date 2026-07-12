{
  config,
  lib,
  osConfig ? null,
  pkgs,
  ...
}:
let
  osDesktopEnabled = osConfig != null && osConfig.custom.desktop.enable;
  wechatAppimageTools = pkgs.appimageTools // {
    wrapAppImage =
      args:
      pkgs.appimageTools.wrapAppImage (
        args
        // {
          extraPkgs =
            appPkgs:
            (args.extraPkgs or (_: [ ])) appPkgs
            ++ [
              appPkgs.fcitx5-gtk
              appPkgs.libsForQt5.fcitx5-qt
              appPkgs.qt6Packages.fcitx5-qt
            ];
          profile = (args.profile or "") + ''
            export QT_IM_MODULE=fcitx
            export SDL_IM_MODULE=fcitx
            export XMODIFIERS=@im=fcitx
          '';
        }
      );
  };
  wechat = pkgs.callPackage "${pkgs.path}/pkgs/by-name/we/wechat/package.nix" {
    callPackage =
      path: args:
      pkgs.callPackage path (
        args
        // lib.optionalAttrs (builtins.baseNameOf (toString path) == "linux.nix") {
          appimageTools = wechatAppimageTools;
        }
      );
  };
in
{
  options.custom.desktop.enable = lib.mkEnableOption "desktop Home Manager role" // {
    default = osDesktopEnabled;
  };

  imports = [
    ../server
    ./browser.nix
    ./documents.nix
    ./files.nix
    ./input-method.nix
    ./media.nix
    ./office.nix
    ./terminal.nix
    ./wallpaper.nix
    ./dms
  ];

  config = lib.mkIf config.custom.desktop.enable {
    home = {
      packages = [
        wechat
      ];

      activation.migrateKvantumBase16Theme = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
        themeDir="${config.xdg.configHome}/Kvantum/Base16Kvantum"

        if [ -L "$themeDir" ]; then
          target="$(readlink "$themeDir")"
          if [[ "$target" == /nix/store/*-home-manager-files/.config/Kvantum/Base16Kvantum ]]; then
            run rm "$themeDir"
          fi
        fi
      '';
    };
  };
}
