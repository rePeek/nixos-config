{
  config,
  lib,
  ...
}:

let
  cfg = config.custom.tuning.io;
in
{
  options.custom.tuning.io = {
    enable = lib.mkEnableOption "I/O-oriented system tuning";

    tmp = {
      useTmpfs = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use tmpfs for /tmp by default on tuned hosts.";
      };

      size = lib.mkOption {
        type = lib.types.str;
        default = "50%";
        description = "Default tmpfs size for /tmp when tmpfs is enabled.";
      };
    };

    swap.zram.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable zram swap by default on tuned hosts.";
    };

    fs.trim.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable periodic trim by default on tuned hosts.";
    };

    vm = {
      dirtyRatio = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "Default vm.dirty_ratio for tuned hosts.";
      };

      dirtyBackgroundRatio = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "Default vm.dirty_background_ratio for tuned hosts.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.tmp = {
      useTmpfs = lib.mkDefault cfg.tmp.useTmpfs;
      tmpfsSize = lib.mkDefault cfg.tmp.size;
    };

    zramSwap.enable = lib.mkDefault cfg.swap.zram.enable;
    services.fstrim.enable = lib.mkDefault cfg.fs.trim.enable;

    boot.kernel.sysctl = lib.mkMerge [
      (lib.mkIf (cfg.vm.dirtyRatio != null) {
        "vm.dirty_ratio" = lib.mkDefault cfg.vm.dirtyRatio;
      })

      (lib.mkIf (cfg.vm.dirtyBackgroundRatio != null) {
        "vm.dirty_background_ratio" = lib.mkDefault cfg.vm.dirtyBackgroundRatio;
      })
    ];
  };
}
