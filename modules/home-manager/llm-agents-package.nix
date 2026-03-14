{ inputs, pkgs, ... }:

{
  home.packages = with inputs.llm-agents.packages.${pkgs.system}; [
    crush
  ];
}
