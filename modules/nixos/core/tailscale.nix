{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.custom.core.tailscale;
in
{
  options.custom.core.tailscale = {
    enable = lib.mkEnableOption "Tailscale service";
    advertiseExitNode = lib.mkEnableOption "Tailscale exit node advertising";
    acceptDns = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to accept DNS settings from the tailnet.";
    };
  };

  config = lib.mkIf cfg.enable {
    # 1. Enable the service and the firewall
    services.tailscale = {
      enable = true;
      package = pkgs.tailscale;
      useRoutingFeatures = lib.mkIf cfg.advertiseExitNode "server";
      extraUpFlags = lib.optionals cfg.advertiseExitNode [
        "--advertise-exit-node"
      ];
      extraSetFlags = lib.optionals (!cfg.acceptDns) [
        "--accept-dns=false"
      ];
    };
    networking.nftables.enable = true;
    networking.hosts = {
      "100.66.72.6" = [
        "sumatran"
        "sumatran.tailfd7184.ts.net"
      ];
      "100.71.185.73" = [
        "bengal"
        "bengal.tailfd7184.ts.net"
      ];
      "100.82.124.57" = [
        "malayan"
        "malayan.tailfd7184.ts.net"
      ];
      "100.71.17.17" = [
        "amur"
        "amur.tailfd7184.ts.net"
      ];
    };
    networking.firewall = {
      enable = true;
      # Always allow traffic from your Tailscale network
      trustedInterfaces = [ "tailscale0" ];
      # Allow the Tailscale UDP port through the firewall
      allowedUDPPorts = [ config.services.tailscale.port ];
    };

    # 2. Force tailscaled to use nftables (Critical for clean nftables-only systems)
    # This avoids the "iptables-compat" translation layer issues.
    systemd.services.tailscaled.serviceConfig.Environment = [
      "TS_DEBUG_FIREWALL_MODE=nftables"
    ];

    # 3. Optimization: Prevent systemd from waiting for network online
    # (Optional but recommended for faster boot with VPNs)
    systemd.network.wait-online.enable = false;
    boot.initrd.systemd.network.wait-online.enable = false;
  };
}
