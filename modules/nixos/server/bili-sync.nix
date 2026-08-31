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

    user = lib.mkOption {
      type = lib.types.str;
      default = "bili-sync";
      description = "User account under which the Bili-Sync service runs.";
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

    downloadOwner = lib.mkOption {
      type = lib.types.str;
      default = "bili-sync";
      description = "User that owns the download directory.";
    };

    downloadGroup = lib.mkOption {
      type = lib.types.str;
      default = "bili-sync";
      description = "Group that owns downloaded files, typically a shared media group.";
    };

    traverseDirectories = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = [ "/home/example" ];
      description = ''
        Parent directories through which the Bili-Sync service account needs
        execute-only access in order to reach the download directory.
      '';
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
    users.users.bili-sync = lib.mkIf (cfg.user == "bili-sync") {
      isSystemUser = true;
      group = "bili-sync";
      extraGroups = lib.optional (cfg.downloadGroup != "bili-sync") cfg.downloadGroup;
      home = cfg.configDirectory;
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.configDirectory} 0700 ${cfg.user} bili-sync -"
      "Z ${cfg.configDirectory} - ${cfg.user} bili-sync -"
      "d ${cfg.downloadDirectory} 2770 ${cfg.downloadOwner} ${cfg.downloadGroup} -"
    ];

    systemd.services.bili-sync = {
      description = "Bili-Sync Bilibili synchronization service";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      requires = lib.optional (cfg.traverseDirectories != [ ]) "bili-sync-directory-access.service";
      after = [
        "network-online.target"
      ]
      ++ lib.optional (cfg.traverseDirectories != [ ]) "bili-sync-directory-access.service";

      environment = {
        BILI_SYNC_CONFIG_DIR = cfg.configDirectory;
        HOME = cfg.configDirectory;
      };

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
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

    systemd.services.bili-sync-directory-access = lib.mkIf (cfg.traverseDirectories != [ ]) {
      description = "Grant Bili-Sync access through parent directories";
      before = [ "bili-sync.service" ];

      # Reapply the ACL before every Bili-Sync start because chmod(2) on a
      # parent directory can reset the ACL mask after tmpfiles has run.
      script = lib.concatMapStringsSep "\n" (
        directory:
        "${lib.getExe' pkgs.acl "setfacl"} -m u:${cfg.user}:--x,m::--x ${lib.escapeShellArg directory}"
      ) cfg.traverseDirectories;

      serviceConfig.Type = "oneshot";
    };
  };
}
