{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.custom.service.desktop.enable && config.custom.features.audio.enable) {
    environment.systemPackages = with pkgs; [
      pavucontrol
    ];
  };
}
