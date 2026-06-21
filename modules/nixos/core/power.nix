{
  config,
  lib,
  ...
}:

let
  cfg = config.custom.core.power;
in
{
  options.custom.core.power = {
    profile = lib.mkOption {
      type = lib.types.enum [
        "performance"
        "efficiency"
      ];
      default = "performance";
      description = "Power profile.";
    };
  };

  config = {
    powerManagement.cpuFreqGovernor = lib.mkIf (cfg.profile == "performance") "performance";

    services = lib.mkMerge [
      (lib.mkIf (cfg.profile == "efficiency") {
        tuned = {
          enable = true;
          settings.dynamic_tuning = true;
        };
        power-profiles-daemon.enable = false;
        tlp.enable = false;
      })
    ];
  };
}
