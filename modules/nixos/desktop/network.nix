{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.custom.desktop.network;
in
{
  options.custom.desktop.network.enable = lib.mkEnableOption "desktop network GUI tools";

  config = lib.mkIf (config.custom.service.desktop.enable && cfg.enable) {
    environment.systemPackages = with pkgs; [
      networkmanagerapplet
    ];
  };
}
