# Docker-backed CLI proxy API service.
{ config, lib, ... }:

let
  cfg = config.custom.server.cli-proxy-api;
in
{
  options.custom.server.cli-proxy-api = {
    enable = lib.mkEnableOption "CLIProxyAPI OCI container";

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = /var/lib/cli-proxy-api;
      description = "Persistent data directory for CLIProxyAPI.";
    };

    image = lib.mkOption {
      type = lib.types.str;
      default = "eceasy/cli-proxy-api:latest";
    };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8317;
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open the CLIProxyAPI port in the firewall.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;
    virtualisation.oci-containers.backend = "docker";

    systemd.tmpfiles.rules = [
      "d ${toString cfg.dataDir} 0700 root root -"
      "d ${toString cfg.dataDir}/auths 0700 root root -"
      "d ${toString cfg.dataDir}/logs 0750 root root -"
      "f ${toString cfg.dataDir}/config.yaml 0600 root root -"
    ];

    virtualisation.oci-containers.containers.cli-proxy-api = {
      image = cfg.image;
      autoStart = true;

      ports = [
        "${cfg.listenAddress}:${toString cfg.port}:8317"
      ];

      volumes = [
        "${toString cfg.dataDir}/config.yaml:/CLIProxyAPI/config.yaml:ro"
        "${toString cfg.dataDir}/auths:/root/.cli-proxy-api"
        "${toString cfg.dataDir}/logs:/CLIProxyAPI/logs"
      ];

      extraOptions = [
        "--pull=always"
        "--add-host=host.docker.internal:host-gateway"
      ];

      environment = {
        HTTP_PROXY = "http://host.docker.internal:7890";
        HTTPS_PROXY = "http://host.docker.internal:7890";
        ALL_PROXY = "socks5://host.docker.internal:7890";
        NO_PROXY = "127.0.0.1,localhost,::1";
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };
}
