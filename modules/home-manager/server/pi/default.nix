# Pi coding agent Home Manager entry point.
#
# This module ensures peer dependency consistency by linking pi's core packages
# to the extension directory after activation.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  piCoreDir = "${pkgs.pi-coding-agent}/lib/node_modules/pi-monorepo/node_modules/@earendil-works";
in
{
  imports = [
    ./pi-cc-extensions.nix
    ./pi-hashline.nix
    ./pi-fff.nix
    ./pi-web-access.nix
    ./pi-themes-bundle.nix
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
      theme = "dracula";
      enableInstallTelemetry = false;
      hideThinkingBlock = true;
      showCacheMissNotices = true;
    };
  };

  home.sessionVariables = {
    PI_SKIP_VERSION_CHECK = "1";
    PI_CODING_AGENT_DIR = "${config.home.homeDirectory}/.pi/agent";
    PI_OFFLINE = "1";
  };

  # Ensure peer dependencies are available after npm install
  home.activation.linkPiCorePackages = lib.mkAfter ''
    PI_NPM_DIR="${config.home.homeDirectory}/.pi/agent/npm/node_modules/@earendil-works"
    if [ -d "${piCoreDir}" ]; then
      mkdir -p "$PI_NPM_DIR"
      for pkg in pi-agent-core pi-ai pi-client pi-protocol pi-telemetry pi-tui; do
        [ -d "${piCoreDir}/$pkg" ] && [ ! -e "$PI_NPM_DIR/$pkg" ] && \
          ln -sf "${piCoreDir}/$pkg" "$PI_NPM_DIR/$pkg" 2>/dev/null || true
      done
    fi
  '';
}
