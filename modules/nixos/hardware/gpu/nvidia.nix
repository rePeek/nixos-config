# nvidia.nix
# Configure NVIDIA graphics, Wayland support and container integration.
{ config, lib, ... }:

let
  cfg = config.custom.hardware.gpu.nvidia;
in
{
  options.custom.hardware.gpu.nvidia = {
    enable = lib.mkEnableOption "NVIDIA GPU support";

    # nvidia-powerd is only useful on supported laptops with Dynamic Boost.
    dynamicBoost.enable = lib.mkEnableOption "NVIDIA Dynamic Boost support through nvidia-powerd";
  };

  config = lib.mkIf cfg.enable {
    boot.kernelParams = [
      # NVIDIA DRM framebuffer support is required by Wayland compositors.
      "nvidia-drm.fbdev=1"
    ];

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      modesetting.enable = true;
      powerManagement.enable = true;
      dynamicBoost.enable = cfg.dynamicBoost.enable;
    };

    hardware.nvidia-container-toolkit.enable = true;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
