# Pi coding agent Home Manager entry point.
# Aggregates core settings, theme and per-plugin modules under ./pi/.
{
  config,
  ...
}:
{
  imports = [
    ./theme.nix
    ./pi-hashline.nix
    ./pi-fff.nix
    ./pi-web-access.nix
    ./pi-codex-search.nix
    ./pi-tool-display.nix
  ];

  # pi 运行时会把 settings.json 改写为紧凑 JSON，
  # 与 HM 生成的 pretty-printed 版本字节不同，需要强制覆盖。
  home.file."${config.programs.pi-coding-agent.configDir}/settings.json".force = true;

  programs.pi-coding-agent = {
    enable = true;

    settings = {
      defaultProvider = "deepseek";
      defaultModel = "deepseek-v4-pro";
      defaultThinkingLevel = "high";

      enableInstallTelemetry = false;
      hideThinkingBlock = true;

      # 做缓存实验时保留
      showCacheMissNotices = true;
    };
  };

  home.sessionVariables = {
    PI_SKIP_VERSION_CHECK = "1";
    PI_CODING_AGENT_DIR = "${config.home.homeDirectory}/.pi/agent";
    PI_OFFLINE = "1";
  };
}
