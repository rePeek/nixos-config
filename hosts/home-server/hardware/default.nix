{
  imports = [
    ./hardware-configuration.nix
    ./filesystem.nix
  ];

  custom.hardware = {
    boot.mode = "uefi";
    cpu.intel.enable = true;
    firmware.enable = true;
    storage.ssd.enable = true;
  };
}
