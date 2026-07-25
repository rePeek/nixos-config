# CLIProxyAPI 二进制包与配置文件。
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

  yaml = pkgs.formats.yaml { };

  cpaConfig = yaml.generate "cli-proxy-api.yaml" {
    # 只允许本机访问。
    # 需要局域网访问时改成 "0.0.0.0"。
    host = "127.0.0.1";
    port = 8317;

    # OAuth 登录文件必须存放在可写目录。
    auth-dir = cfg.dataDir + "/auth";

    # 注意：真实密钥放这里会进入 Nix store。
    # 初期测试可以这样用，后面建议改成 sops-nix。
    api-keys = [
      "sk-1234"
    ];

    debug = false;

    # 建议由 journald 保存日志。
    logging-to-file = false;
    usage-statistics-enabled = false;

    remote-management = {
      # 即便 API 绑定到 0.0.0.0，管理接口也只允许本机。
      allow-remote = false;

      # 空值表示关闭 Management API。
      secret-key = "112358";

      disable-control-panel = false;

      # 管理面板 static 资源通过 MANAGEMENT_STATIC_PATH 预置在 Nix store，
      # 不需要运行时自动更新。
      disable-auto-update-panel = true;
    };

    routing = {
      strategy = "round-robin";

      # 同一会话尽量固定使用同一个账号，
      # 对多轮对话和 prompt cache 更友好。
      session-affinity = true;
      session-affinity-ttl = "1h";
    };

    request-retry = 3;
    max-retry-credentials = 0;
    max-retry-interval = 30;

    ws-auth = true;

    quota-exceeded = {
      switch-project = true;
      switch-preview-model = true;
      antigravity-credits = true;
    };

    codex = {
      identity-confuse = false;
      optimize-multi-agent-v2 = false;
    };

    plugins = {
      enabled = false;
      dir = cfg.dataDir + "/plugins";
      configs = { };
    };
  };
in
{
  options.custom.server.cpa = {
    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/cli-proxy-api";
      description = "CPA runtime data directory (config, auth, plugins).";
    };

    configPath = lib.mkOption {
      type = lib.types.str;
      default = "${cfg.dataDir}/config.yaml";
      readOnly = true;
      description = "Resolved config file path, used by both config and service modules.";
    };

    configFile = lib.mkOption {
      type = lib.types.path;
      default = cpaConfig;
      readOnly = true;
      internal = true;
      description = "Nix store path of the generated config file.";
    };
  };

  config = lib.mkIf cfg.enable {
    # 让你可以直接在终端运行 cli-proxy-api。
    environment.systemPackages = [
      cpa
    ];
  };
}
