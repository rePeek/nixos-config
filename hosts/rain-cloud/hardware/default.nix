{
  imports = [
    ./hardware-configuration.nix
    ./filesystem.nix
  ];

  custom.hardware = {
    boot.mode = "bios";
    storage.ssd.enable = true;
  };
}
