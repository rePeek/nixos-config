# Bili-Sync service built from the configured source Flake.
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.custom.server.bili-sync;
in
{
  options.custom.server.bili-sync = {
    enable = lib.mkEnableOption "Bili-Sync service";

    package = lib.mkOption {
      type = lib.types.package;
      default = inputs.bili-sync.packages.${pkgs.stdenv.hostPlatform.system}.bili-sync;
      defaultText = lib.literalExpression "inputs.bili-sync.packages.\${pkgs.stdenv.hostPlatform.system}.bili-sync";
      description = "Bili-Sync package to run.";
    };

    configDirectory = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/bili-sync";
      description = "Directory containing the Bili-Sync database and private configuration.";
    };

    downloadDirectory = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/bili-sync/downloads";
      description = "Working directory used as the base for relative download paths.";
    };

    downloadGroup = lib.mkOption {
      type = lib.types.str;
      default = "bili-sync";
      description = "Group that owns downloaded files, typically a shared media group.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 12345;
      description = "TCP port to allow when openFirewall is enabled; it must match Bili-Sync's bind address.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to allow access to the Bili-Sync Web UI through the firewall.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;

    users.groups.bili-sync = { };
    users.users.bili-sync = {
      isSystemUser = true;
      group = "bili-sync";
      extraGroups = lib.optional (cfg.downloadGroup != "bili-sync") cfg.downloadGroup;
      home = cfg.configDirectory;
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.configDirectory} 0700 bili-sync bili-sync -"
      "d ${cfg.downloadDirectory} 2750 bili-sync ${cfg.downloadGroup} -"
    ];

    systemd.services.bili-sync = {
      description = "Bili-Sync Bilibili synchronization service";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      environment = {
        BILI_SYNC_CONFIG_DIR = cfg.configDirectory;
        HOME = cfg.configDirectory;
      };

      serviceConfig = {
        Type = "simple";
        User = "bili-sync";
        Group = "bili-sync";
        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
        RestartSec = "5s";
        UMask = "0027";
        WorkingDirectory = cfg.downloadDirectory;

        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ReadWritePaths = [
          cfg.configDirectory
          cfg.downloadDirectory
        ];
      };
    };
  };
}
