{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.custom.service.tailscale;
in
{
  options.custom.service.tailscale = {
    enable = lib.mkEnableOption "Tailscale service";
    advertiseExitNode = lib.mkEnableOption "Tailscale exit node advertising";
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
    };
    networking.nftables.enable = true;
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
