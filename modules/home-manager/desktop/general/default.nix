# General GUI defaults installed for every desktop Home Manager role.
{
  config,
  lib,
  ...
}:
{
  imports = [
    ./browser.nix
    ./bottles.nix
    ./documents.nix
    ./files.nix
    ./input-method.nix
    ./media.nix
    ./office.nix
    ./terminal.nix
    ./wallpaper.nix
    ./wechat.nix
    ./dms
  ];

  config = lib.mkIf config.custom.desktop.enable {
    custom.desktop.defaults.wallpaper = {
      enable = true;
      directory = ../../../../assets/wallpapers;
      initialStrategy = "random";
    };

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
