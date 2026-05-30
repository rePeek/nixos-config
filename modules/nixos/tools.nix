{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.custom.tools;
in
{
  options.custom.tools = {
    audio.enable = lib.mkEnableOption "audio CLI tools";
    network.enable = lib.mkEnableOption "network and bluetooth CLI tools";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.audio.enable {
      environment.systemPackages = with pkgs; [
        pulseaudio
        wireplumber
      ];
    })

    (lib.mkIf cfg.network.enable {
      environment.systemPackages = with pkgs; [
        networkmanager
        bluez
      ];
    })
  ];
}
