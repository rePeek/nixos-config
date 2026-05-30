{
  imports = [
    ./hardware-configuration.nix
    ./filesystem.nix
  ];

  custom.hardware = {
    boot.mode = "uefi";
    cpu.intel.enable = true;
    firmware.enable = true;
    power.profile = "efficiency";
    storage.ssd.enable = true;
  };
}
