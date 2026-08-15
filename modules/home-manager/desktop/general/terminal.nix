# General Ghostty terminal defaults for the desktop profile.
{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = {
    home = {
      packages = [ pkgs.ghostty ];
      sessionVariables.TERMINAL = lib.mkDefault "ghostty";
    };

    programs.ghostty = {
      enable = lib.mkDefault true;
    };

    xdg.configFile."xdg-terminals.list".text = lib.mkDefault ''
      com.mitchellh.ghostty.desktop
    '';

    xdg.mimeApps = {
      associations.added.terminal = [ "com.mitchellh.ghostty.desktop" ];
      defaultApplications.terminal = [ "com.mitchellh.ghostty.desktop" ];
    };
  };
}
