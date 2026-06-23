{
  config,
  lib,
  osConfig ? null,
  pkgs,
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
    home = {
      packages = [
        pkgs.wechat
      ];

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
