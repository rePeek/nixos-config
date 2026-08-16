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
        window-padding-balance = true;
        window-padding-color = "extend-always";
      };
    };

    xdg.configFile."xdg-terminals.list".text = lib.mkDefault ''
      com.mitchellh.ghostty.desktop
    '';
  };
}
