{
  imports = [
    ./hardware-configuration.nix
    ./filesystem.nix
  ];

  custom.boot.mode = "uefi";

  custom.hardware = {
    cpu.intel.enable = true;
    firmware.enable = true;
    storage.ssd.enable = true;
  };
}
