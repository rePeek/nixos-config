{
  config,
  lib,
  ...
}:

let
  cfg = config.custom.features.audio;
in
{
  options.custom.features.audio.enable = lib.mkEnableOption "audio stack (PipeWire + WirePlumber)";

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    security.rtkit.enable = true;
    services.pulseaudio.enable = false;
  };
}
