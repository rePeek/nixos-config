{
  imports = [
    ../../modules/nixos
    ../../modules/nixos/extraServices
    ./hardware
    ./user.nix
    ./misc.nix
    ./network.nix
  ];

  modules.desktop.gaming.enable = true;
  modules.network.daed.enable = true;
  modules.virtualization.custom.docker = true;
  # modules.powerManagement.type = "workstation";
}
