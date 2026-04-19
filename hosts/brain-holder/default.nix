{
  imports = [
    ./hardware

    ./user.nix
    ./misc.nix
    ./network.nix

    ../../modules/nixos
    ../../modules/nixos/extraServices
  ];

  modules.desktop.gaming.enable = true;
  modules.network.clash.enable = true;
  modules.virtualization.custom.docker = true;
  modules.virtualization.custom.libvirtd = true;
  # modules.powerManagement.type = "workstation";
}
