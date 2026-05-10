{ inputs, pkgs, ... }:

{
  home.packages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
    hermes-agent
    claude-code
    codex
    cli-proxy-api
    vibe-kanban
    code-review-graph
  ];
}
