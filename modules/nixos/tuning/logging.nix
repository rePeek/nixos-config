{
  config,
  lib,
  ...
}:

let
  cfg = config.custom.tuning.logging;
  journaldConfig = lib.concatStringsSep "\n" (
    lib.filter (line: line != null) [
      "Storage=${cfg.journald.storage}"
      (lib.optionalString (cfg.journald.maxUse != null) "SystemMaxUse=${cfg.journald.maxUse}")
      (lib.optionalString (cfg.journald.maxFileSec != null) "MaxFileSec=${cfg.journald.maxFileSec}")
    ]
  );
in
{
  options.custom.tuning.logging = {
    enable = lib.mkEnableOption "logging-oriented system tuning";

    journald = {
      storage = lib.mkOption {
        type = lib.types.enum [
          "auto"
          "volatile"
          "persistent"
          "none"
        ];
        default = "auto";
        description = "Default journald storage mode for tuned hosts.";
      };

      maxUse = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Default SystemMaxUse for journald.";
      };

      maxFileSec = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Default MaxFileSec for journald.";
      };
    };

    tmpfiles.cleanTmp = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to keep the default tmpfiles tmp cleanup rule.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.journald.extraConfig = lib.mkDefault journaldConfig;
  };
}
