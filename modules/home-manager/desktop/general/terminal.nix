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
        mouse-hide-while-typing = true;
        window-padding-balance = true;
      };
    };

    xdg.configFile."xdg-terminals.list".text = lib.mkDefault ''
      com.mitchellh.ghostty.desktop
    '';
  };
}
