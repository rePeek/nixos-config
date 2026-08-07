# CS2 Home Manager module — deploys autoexec.cfg to the game configuration directory.
{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.custom.desktop.enable {
    xdg.dataFile."Steam/steamapps/common/Counter-Strike Global Offensive/game/csgo/cfg/autoexec.cfg" = {
      source = ./cs-autoexec.cfg;
    };
  };
}
