{
  imports = [
    ./hardware-configuration.nix
    ./filesystem.nix
  ];

  custom.boot.mode = "bios";

  custom.hardware = {
    storage.ssd.enable = true;
  };
}
