# Enable reusable NVIDIA driver and compute capabilities.
{
  config,
  lib,
  ...
}:

let
  cfg = config.custom.desktop.nvidia;
in
{
  options.custom.desktop.nvidia = {
    driver.enable = lib.mkEnableOption "NVIDIA driver defaults";

    compute.enable = lib.mkEnableOption "NVIDIA compute and container integration";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.driver.enable {
      boot.kernelParams = [
        # NVIDIA DRM framebuffer support is required by Wayland compositors.
        "nvidia-drm.fbdev=1"
      ];

      hardware.nvidia = {
        open = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.latest;
        modesetting.enable = true;
        powerManagement.enable = true;
      };
    })

    (lib.mkIf cfg.compute.enable {
      hardware.nvidia.nvidiaPersistenced = true;
      hardware.nvidia-container-toolkit.enable = true;
    })
  ];
}
