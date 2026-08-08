{
  config,
  lib,
  ...
}:

{
  imports = [
    ../server
    ./general
    ./extra
    ./cs-config
  ];

  config = {
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
