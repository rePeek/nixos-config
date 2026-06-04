# nvidia.nix
# Configure NVIDIA graphics, Wayland support and container integration.
{ config, lib, ... }:

let
  cfg = config.custom.hardware.gpu.nvidia;
  hasProfile = profile: lib.elem profile cfg.profiles;
  displayProfile = hasProfile "display";
  computeProfile = hasProfile "compute";
  offloadProfile = hasProfile "offload";
in
{
  options.custom.hardware.gpu.nvidia = {
    enable = lib.mkEnableOption "NVIDIA workstation GPU profile";

    profiles = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "display"
          "compute"
          "offload"
        ]
      );
      default = [ ];
      description = "NVIDIA usage profiles enabled on this host.";
    };

    prime = {
      nvidiaBusId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "NVIDIA GPU PCI bus ID used by PRIME.";
      };

      amdgpuBusId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "AMD GPU PCI bus ID used by PRIME.";
      };

      intelBusId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Intel GPU PCI bus ID used by PRIME.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.profiles != [ ];
        message = "custom.hardware.gpu.nvidia.profiles must include at least one of display, compute, or offload.";
      }
      {
        assertion = !(displayProfile && offloadProfile);
        message = "custom.hardware.gpu.nvidia.profiles cannot combine display and offload.";
      }
      {
        assertion =
          !offloadProfile
          || (
            cfg.prime.nvidiaBusId != null && (cfg.prime.amdgpuBusId != null || cfg.prime.intelBusId != null)
          );
        message = "custom.hardware.gpu.nvidia offload profile requires prime.nvidiaBusId and one of prime.amdgpuBusId or prime.intelBusId.";
      }
      {
        assertion = !(cfg.prime.amdgpuBusId != null && cfg.prime.intelBusId != null);
        message = "custom.hardware.gpu.nvidia.prime must not set both amdgpuBusId and intelBusId.";
      }
    ];

    boot.kernelParams = lib.mkIf (displayProfile || offloadProfile) [
      # NVIDIA DRM framebuffer support is required by Wayland compositors.
      "nvidia-drm.fbdev=1"
    ];

    services.xserver.videoDrivers = lib.mkIf (displayProfile || offloadProfile) [ "nvidia" ];

    hardware.nvidia = {
      open = true;
      nvidiaSettings = displayProfile || offloadProfile;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      modesetting.enable = displayProfile || offloadProfile;
      powerManagement.enable = true;
      nvidiaPersistenced = computeProfile || offloadProfile;

      prime = {
        nvidiaBusId = lib.mkIf (cfg.prime.nvidiaBusId != null) cfg.prime.nvidiaBusId;
        amdgpuBusId = lib.mkIf (cfg.prime.amdgpuBusId != null) cfg.prime.amdgpuBusId;
        intelBusId = lib.mkIf (cfg.prime.intelBusId != null) cfg.prime.intelBusId;

        offload = {
          enable = offloadProfile;
          enableOffloadCmd = offloadProfile;
        };
      };
    };

    hardware.nvidia-container-toolkit.enable = computeProfile;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
