# intel.nix
# Configure Intel integrated graphics with common runtime acceleration drivers.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.custom.features.gpu.intel;
in
{
  options.custom.features.gpu.intel.enable = lib.mkEnableOption "Intel integrated GPU support";

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
      ];
    };
  };
}
