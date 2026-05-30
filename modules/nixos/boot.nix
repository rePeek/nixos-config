# boot.nix
# Configure shared boot defaults and select the host boot mode.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.custom.boot;
in
{
  options.custom.boot = {
    mode = lib.mkOption {
      type = lib.types.enum [
        "bios"
        "uefi"
      ];
      description = "Boot mode used by this host.";
    };

    grubDevice = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Optional disk where GRUB is installed in BIOS mode. Disko can configure this automatically.";
    };
  };

  config = lib.mkMerge [
    {
      boot.kernelPackages = lib.mkDefault pkgs.linuxPackages;
      boot.loader.timeout = lib.mkDefault 8;
    }

    (lib.mkIf (cfg.mode == "uefi") {
      boot.loader.systemd-boot = {
        enable = true;
        configurationLimit = lib.mkDefault 10;
        consoleMode = lib.mkDefault "max";
      };

      boot.loader.efi.canTouchEfiVariables = true;
    })

    (lib.mkIf (cfg.mode == "bios") {
      boot.loader.grub = {
        enable = true;
        configurationLimit = lib.mkDefault 10;
      }
      // lib.optionalAttrs (cfg.grubDevice != null) {
        device = cfg.grubDevice;
      };
    })
  ];
}
