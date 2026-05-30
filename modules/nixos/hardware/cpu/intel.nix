# intel.nix
# Configure Intel CPU microcode updates and KVM support.
{
  config,
  lib,
  ...
}:

let
  cfg = config.custom.hardware.cpu.intel;
in
{
  options.custom.hardware.cpu.intel.enable = lib.mkEnableOption "Intel CPU support";

  config = lib.mkIf cfg.enable {
    boot.kernelModules = [ "kvm-intel" ];
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
