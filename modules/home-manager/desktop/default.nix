{
  config,
  lib,
  osConfig ? null,
  ...
}:
let
  osDesktopEnabled = osConfig != null && osConfig.custom.desktop.enable;
in
{
  options.custom.desktop.enable = lib.mkEnableOption "desktop Home Manager role" // {
    default = osDesktopEnabled;
  };

  imports = [
    ../server
    ./general
    ./extra
  ];

  config = lib.mkIf config.custom.desktop.enable {
    home = {
      pointerCursor.enable = lib.mkDefault true;

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
