# CS2 Home Manager module — deploys the launcher and autoexec.cfg.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.desktop.cs2;

  cs2-launcher =
    let
      gamemoderun = "${lib.getExe' pkgs.gamemode "gamemoderun"}";
      mangohud = "${lib.getExe' pkgs.mangohud "mangohud"}";
      gamescope = "${lib.getExe' pkgs.gamescope "gamescope"}";

      cs2-sh = "$HOME/.local/share/Steam/steamapps/common/Counter-Strike Global Offensive/game/cs2.sh";

      cs2-args = lib.concatStringsSep " " [
        "-sdlaudiodriver pipewire"
        "-nojoy"
        "-fullscreen"
        "-perfectworld"
        "+engine_low_latency_sleep_after_client_tick true"
        "+exec autoexec.cfg"
        "+fps_max 0"
      ];

      # Wrapper chain: gamescope → mangohud → gamemoderun → cs2.sh
      inner = "${gamemoderun} ${cs2-sh} ${cs2-args}";
      withMangohud = if cfg.mangohud.enable then "${mangohud} ${inner}" else inner;
      outer =
        if cfg.gamescope.enable then
          let
            gamescopeArgs = lib.concatStringsSep " " cfg.gamescope.args;
          in
          "${gamescope} ${gamescopeArgs} -- ${withMangohud}"
        else
          withMangohud;
    in
    pkgs.writeShellScriptBin "cs2-launcher" ''
      exec ${outer} "$@"
    '';
in
{
  options.custom.desktop.cs2 = {
    enable = lib.mkEnableOption "CS2 launcher and configuration";

    mangohud.enable = lib.mkEnableOption "MangoHud overlay" // {
      default = true;
    };

    gamescope = {
      enable = lib.mkEnableOption "Gamescope compositor" // {
        default = false;
      };

      args = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "-W"
          "2560"
          "-H"
          "1440"
          "-r"
          "240"
          "--"
        ];
        description = "Arguments passed to gamescope before '--'.";
      };
    };
  };

  config = lib.mkIf (config.custom.desktop.enable && cfg.enable) {
    home.packages = [ cs2-launcher ];

    xdg.dataFile."Steam/steamapps/common/Counter-Strike Global Offensive/game/csgo/cfg/autoexec.cfg" = {
      source = ./cs-autoexec.cfg;
    };
  };
}
