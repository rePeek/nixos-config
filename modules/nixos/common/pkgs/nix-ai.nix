{ inputs, pkgs, ... }:
{
  environment.systemPackages = with inputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system}; [
    # claude-code
    # opencode
    # gemini-cli
    # qwen-code
    # ... other tools
    crush
  ];
}
