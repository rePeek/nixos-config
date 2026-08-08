# WeChat AppImage configuration with Fcitx support.
{
  lib,
  pkgs,
  ...
}:
let
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
  config = {
    home.packages = [ wechat ];
  };
}
