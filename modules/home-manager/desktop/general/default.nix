# General GUI defaults installed for every desktop Home Manager role.
{
  config,
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
  imports = [
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
    custom.desktop.defaults.wallpaper = {
      enable = true;
      directory = ../../../../assets/wallpapers;
      initialStrategy = "random";
    };

    home.packages = [ wechat ];

    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      desktop = config.home.homeDirectory;
      download = config.home.homeDirectory + "/Downloads";
    };

    xdg.configFile."mimeapps.list".force = lib.mkDefault true;
    xdg.mimeApps.enable = lib.mkDefault true;
  };
}
