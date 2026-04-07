{
  imports = [
    ./hardware

    ./user.nix
    ./misc.nix
    ./network.nix
    ./clash-verge.nix

    ../../modules/nixos
    ../../modules/nixos/extraServices
  ];

  modules.desktop.gaming.enable = true;
  # modules.network.daed.enable = true;
  modules.virtualization.custom.docker = true;
  # modules.powerManagement.type = "workstation";
}
