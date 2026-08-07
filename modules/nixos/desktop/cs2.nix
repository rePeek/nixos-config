# CS2 native launch options — cleaned up from legacy CS:GO cvars.
# Adds a declarative CS2 wrapper to Steam extras.
#
# The nixpkgs programs.steam.config.apps option does not exist yet
# (as of 2026-07 nixos-unstable).  Until that lands, this module
# provides a custom.desktop.gaming.cs2 option that creates a minimal
# wrapper script and adds it to programs.steam.extraPackages, so the
# launch options appear next to Steam.
#
# When the upstream option arrives, migrate to it directly.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.custom.desktop.gaming.cs2;

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
            gArgs = lib.concatStringsSep " " cfg.gamescope.args;
          in
          "${gamescope} ${gArgs} -- ${withMangohud}"
        else
          withMangohud;
    in
    pkgs.writeShellScriptBin "cs2-launcher" ''
      exec ${outer} "$@"
    '';
in

{
  options.custom.desktop.gaming.cs2 = {
    enable = lib.mkEnableOption "declarative CS2 launch wrapper";

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

  config =
    lib.mkIf (config.custom.desktop.enable && config.custom.desktop.gaming.enable && cfg.enable)
      {
        programs.steam.extraPackages = [ cs2-launcher ];
      };
}
