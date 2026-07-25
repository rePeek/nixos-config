# CLIProxyAPI 系统用户、数据目录和 systemd 服务。
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.custom.server.cpa;

  system = pkgs.stdenv.hostPlatform.system;

  cpa = inputs.llm-agents.packages.${system}.cli-proxy-api;

  # 构建时从 GitHub Release 下载管理面板 HTML，存入 Nix store。
  # 更新 CPA 版本后如果面板也更新了，需要同步更新 hash。
  # 获取最新 hash:
  #   nix-prefetch-url https://github.com/router-for-me/Cli-Proxy-API-Management-Center/releases/download/<tag>/management.html
  managementHtml = pkgs.fetchurl {
    url = "https://github.com/router-for-me/Cli-Proxy-API-Management-Center/releases/download/v1.19.1/management.html";
    sha256 = "0hv71qc843xxa6kfrclyq3iilq039z4j2n48mhw7pa2c5g7s5j68";
  };

  managementStaticDir = pkgs.runCommand "cpa-management-static" { } ''
    mkdir -p $out
    ln -s ${managementHtml} $out/management.html
  '';
in
{
  config = lib.mkIf cfg.enable {
    users.groups.cli-proxy-api = { };

    users.users.cli-proxy-api = {
      isSystemUser = true;
      group = "cli-proxy-api";

      home = cfg.dataDir;
      createHome = true;
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir}         0700 cli-proxy-api cli-proxy-api -"
      "d ${cfg.dataDir}/auth    0700 cli-proxy-api cli-proxy-api -"
      "d ${cfg.dataDir}/plugins 0700 cli-proxy-api cli-proxy-api -"
    ];

    systemd.services.cli-proxy-api = {
      description = "CLIProxyAPI";
      documentation = [ "https://github.com/router-for-me/CLIProxyAPI" ];

      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      # 管理面板 static 资源预置在 Nix store，避免运行时下载。
      environment.MANAGEMENT_STATIC_PATH = "${managementStaticDir}";

      serviceConfig = {
        Type = "simple";

        User = "cli-proxy-api";
        Group = "cli-proxy-api";

        WorkingDirectory = cfg.dataDir;

        # 每次启动前从 Nix store 复制最新配置到可写目录。
        # 管理面板运行时会写入此文件，所以不能用只读的 /etc 路径。
        ExecStartPre = "+${pkgs.coreutils}/bin/install -o cli-proxy-api -g cli-proxy-api -m 0600 ${cfg.configFile} ${cfg.configPath}";

        ExecStart = ''
          ${lib.getExe cpa} \
            -config ${cfg.configPath}
        '';

        Restart = "on-failure";
        RestartSec = "5s";

        # systemd 安全加固。
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";

        ReadWritePaths = [
          cfg.dataDir
        ];

        UMask = "0077";
      };
    };
  };
}
