# Pi coding agent Home Manager entry point.
# Aggregates core settings, theme and per-plugin modules under ./pi/.
{
  config,
  ...
}:
{
  imports = [
    ./theme.nix
    ./hashline.nix
    ./pi-fff.nix
    ./pi-web-access.nix
    ./pi-codex-search.nix
    ./pi-tool-display.nix
  ];

  programs.pi-coding-agent = {
    enable = true;

    settings = {
      defaultProvider = "csi-provider";
      defaultModel = "Qwen3.7-Max";
      defaultThinkingLevel = "high";

      enableInstallTelemetry = false;
      hideThinkingBlock = true;

      # 做缓存实验时保留
      showCacheMissNotices = true;
    };

    models.providers = {
      csi-provider = {
        baseUrl = "http://113.46.219.251:8080/v1";
        api = "openai-completions";
        authHeader = true;

        models = [
          {
            id = "GLM-5.2";
            name = "GLM-5.2 (CSI)";

            reasoning = true;
            contextWindow = 1000000;
            maxTokens = 131072;

            thinkingLevelMap = {
              minimal = null;
              low = null;
              medium = null;
              high = "high";
              xhigh = null;
              max = "max";
            };

            compat = {
              thinkingFormat = "zai";
              supportsReasoningEffort = true;
              supportsDeveloperRole = false;
              maxTokensField = "max_tokens";
              zaiToolStream = true;
            };
          }
          {
            id = "Qwen3.7-Max";
            name = "Qwen3.7-Max (CSI)";

            reasoning = true;
            contextWindow = 1000000;
            maxTokens = 65536;

            thinkingLevelMap = {
              minimal = null;
              low = null;
              medium = null;
              high = "high";
              xhigh = null;
              max = null;
            };

            compat = {
              thinkingFormat = "qwen";
              supportsReasoningEffort = false;
              supportsDeveloperRole = false;
              maxTokensField = "max_tokens";
            };
          }
        ];
      };
    };
  };

  home.sessionVariables = {
    PI_SKIP_VERSION_CHECK = "1";
    PI_CODING_AGENT_DIR = "${config.home.homeDirectory}/.pi/agent";
  };
}
