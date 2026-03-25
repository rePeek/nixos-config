{ lib, config, ... }:
{
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # 直接将CPU调速器设为 performance
  powerManagement.cpuFreqGovernor = "performance";
}
