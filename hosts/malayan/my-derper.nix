{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.my-derper;
in
{
  options = {
    services.my-derper = {
      enable = lib.mkEnableOption "custom DERP server";

      ip = lib.mkOption {
        type = lib.types.str;
        example = "103.205.254.65";
        description = "Public IP address used by derper and its self-signed IP certificate.";
      };

      package = lib.mkPackageOption pkgs [ "tailscale" "derper" ] { };

      derpPort = lib.mkOption {
        type = lib.types.port;
        default = 443;
        description = "Local TCP port derper listens on.";
      };

      stunPort = lib.mkOption {
        type = lib.types.port;
        default = 3478;
        description = "Local UDP port derper uses for STUN.";
      };

      verifyClients = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to verify clients via local tailscaled.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to open local firewall for derpPort/stunPort.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.derpPort ];
      allowedUDPPorts = [ cfg.stunPort ];
    };

    services.tailscale.enable = lib.mkIf cfg.verifyClients true;

    systemd.services.my-derper = {
      preStart = ''
        install -d -m 0755 /var/lib/derper
        install -d -m 0755 /var/lib/derper/certs

        if [ ! -f /var/lib/derper/certs/${cfg.ip}.crt ] || [ ! -f /var/lib/derper/certs/${cfg.ip}.key ]; then
          echo "Generating self-signed IP certificate for ${cfg.ip}"
          ${pkgs.openssl}/bin/openssl req \
            -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
            -keyout /var/lib/derper/certs/${cfg.ip}.key \
            -out /var/lib/derper/certs/${cfg.ip}.crt \
            -subj "/CN=${cfg.ip}" \
            -addext "subjectAltName=IP:${cfg.ip}"
        fi
      '';

      serviceConfig = {
        ExecStart =
          "${lib.getExe' cfg.package "derper"}"
          + " --hostname=${cfg.ip}"
          + " --certmode=manual"
          + " --certdir=/var/lib/derper/certs"
          + " --a=:${toString cfg.derpPort}"
          + " --stun"
          + " --stun-port=${toString cfg.stunPort}"
          + " -c /var/lib/derper/derper.key"
          + lib.optionalString cfg.verifyClients " --verify-clients";

        DynamicUser = true;
        Restart = "always";
        RestartSec = "5sec";
        StateDirectory = "derper";
        Type = "simple";

        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];

        DeviceAllow = null;
        LockPersonality = true;
        NoNewPrivileges = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateUsers = false;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" ];
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}
