# cachyos.nix
# Configure CachyOS kernel packages for hosts that explicitly enable them.
{
  config,
  inputs,
  lib,
  ...
}:

let
  cfg = config.custom.hardware.kernel.cachyos;
in
{
  options.custom.hardware.kernel.cachyos = {
    enable = lib.mkEnableOption "CachyOS kernel support";

    package = lib.mkOption {
      type = lib.types.nullOr lib.types.raw;
      default = null;
      description = "CachyOS kernel package set selected by this host.";
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      inputs.nix-cachyos-kernel.overlays.pinned
    ];

    boot.kernelPackages = lib.mkIf (cfg.package != null) cfg.package;
  };
}
