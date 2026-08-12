{ lib, ... }:

{
  config = {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
      wireplumber.extraConfig."10-bluetooth-profile-switching" = {
        "wireplumber.settings" = {
          # DMS provides an explicit A2DP/HFP selector. Keep manual selections
          # stable instead of restoring A2DP when the last capture stream ends.
          "bluetooth.autoswitch-to-headset-profile" = false;
        };
      };
    };

    security.rtkit.enable = true;
    services.pulseaudio.enable = false;

  };
}
