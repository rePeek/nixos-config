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
    ./flatpak.nix
    ./input-method.nix
    ./media.nix
    ./office.nix
    ./terminal.nix
    ./wallpaper.nix
    ./dms
  ];

  config = {
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      desktop = config.home.homeDirectory;
      documents = null;
      download = config.home.homeDirectory + "/Downloads";
      music = null;
      pictures = config.home.homeDirectory + "/Pictures";
      publicShare = null;
      templates = null;
      videos = null;
    };

    xdg.configFile."mimeapps.list".force = lib.mkDefault true;
    xdg.mimeApps.enable = lib.mkDefault true;
  };
}
