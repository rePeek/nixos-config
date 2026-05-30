{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.custom.service.desktop.enable && config.custom.hardware.audio.enable) {
    environment.systemPackages = with pkgs; [
      pavucontrol
    ];
  };
}
