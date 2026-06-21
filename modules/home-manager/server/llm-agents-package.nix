{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  options.custom.server.llm-agents.enable = lib.mkEnableOption "LLM agent CLI packages" // {
    default = true;
  };

  config.home.packages = lib.mkIf config.custom.server.llm-agents.enable (
    with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
    [
      hermes-agent
      claude-code
      codex
      cli-proxy-api
      vibe-kanban
      code-review-graph
    ]
  );
}
