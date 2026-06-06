{
  config,
  lib,
  ...
}:

let
  cfg = config.custom.tuning.router;

  rpFilterValues = {
    strict = 1;
    loose = 2;
    off = 0;
  };
in
{
  options.custom.tuning.router = {
    enable = lib.mkEnableOption "router-oriented system tuning";

    forwarding = {
      ipv4 = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable IPv4 forwarding by default on router hosts.";
      };

      rpFilter = lib.mkOption {
        type = lib.types.enum [
          "strict"
          "loose"
          "off"
        ];
        default = "strict";
        description = "Reverse path filtering mode for router hosts.";
      };

      conntrackMax = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "Default nf_conntrack_max for router hosts.";
      };
    };

    tcp = {
      congestionControl = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Default TCP congestion control algorithm for router hosts.";
      };

      fastOpen = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable TCP Fast Open by default on router hosts.";
      };
    };

    netdev = {
      rmemMax = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "Default net.core.rmem_max for router hosts.";
      };

      wmemMax = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "Default net.core.wmem_max for router hosts.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernel.sysctl = lib.mkMerge [
      {
        "net.ipv4.ip_forward" = lib.mkDefault (if cfg.forwarding.ipv4 then 1 else 0);
        "net.ipv4.conf.all.rp_filter" = lib.mkDefault rpFilterValues.${cfg.forwarding.rpFilter};
        "net.ipv4.conf.default.rp_filter" = lib.mkDefault rpFilterValues.${cfg.forwarding.rpFilter};
        "net.ipv4.tcp_fastopen" = lib.mkDefault (if cfg.tcp.fastOpen then 3 else 0);
      }

      (lib.mkIf (cfg.forwarding.conntrackMax != null) {
        "net.netfilter.nf_conntrack_max" = lib.mkDefault cfg.forwarding.conntrackMax;
      })

      (lib.mkIf (cfg.tcp.congestionControl != null) {
        "net.ipv4.tcp_congestion_control" = lib.mkDefault cfg.tcp.congestionControl;
      })

      (lib.mkIf (cfg.netdev.rmemMax != null) {
        "net.core.rmem_max" = lib.mkDefault cfg.netdev.rmemMax;
      })

      (lib.mkIf (cfg.netdev.wmemMax != null) {
        "net.core.wmem_max" = lib.mkDefault cfg.netdev.wmemMax;
      })
    ];
  };
}
