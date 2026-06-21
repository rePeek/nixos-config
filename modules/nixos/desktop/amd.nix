# Add AMD graphics inspection tools.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.custom.desktop.amd;
in
{
  options.custom.desktop.amd = {
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
