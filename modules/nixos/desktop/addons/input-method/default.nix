{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.desktop.addons.fcitx5;
  desktopUsers = config.custom.desktop.users;

  fcitx5UserModule = {
    home.sessionVariables = {
      GLFW_IM_MODULE = lib.mkDefault "ibus";
      QT_IM_MODULE = lib.mkDefault "fcitx";
      SDL_IM_MODULE = lib.mkDefault "fcitx";
      XMODIFIERS = lib.mkDefault "@im=fcitx";
    };

    i18n.inputMethod = {
      enable = lib.mkDefault true;
      type = lib.mkDefault "fcitx5";
      fcitx5 = {
        waylandFrontend = lib.mkDefault true;
        addons = with pkgs; [
          qt6Packages.fcitx5-configtool
          qt6Packages.fcitx5-chinese-addons
          fcitx5-gtk
        ];
      };
    };

    xdg.configFile."fcitx5/profile" = {
      source = ./fcitx5-profile;
      force = true;
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
