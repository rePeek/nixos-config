# General Ghostty terminal defaults for the desktop profile.
{
  lib,
  ...
}:

{
  config = {
    home.sessionVariables.TERMINAL = lib.mkDefault "ghostty";

    programs.ghostty = {
      enable = lib.mkDefault true;

      settings = {
        window-padding-x = 0;
        window-padding-y = 0;
        window-padding-balance = false;
        window-padding-color = "extend-always";
      };
    };

    xdg.configFile."xdg-terminals.list".text = lib.mkDefault ''
      com.mitchellh.ghostty.desktop
    '';
  };
}
