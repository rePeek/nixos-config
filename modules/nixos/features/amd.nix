# Add AMD graphics inspection tools.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.custom.features.amd;
in
{
  options.custom.features.amd = {
    enable = lib.mkEnableOption "AMD graphics inspection tools";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libva-utils
      mesa-demos
      vulkan-tools
    ];
  };
}
