{ inputs, pkgs, ... }:

{
  home.packages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
    crush
    claude-code
    codex
    beads
  ];
}
