{
  networking.hostName = "brain-holder";

  imports = [
    ./hardware

    ./user.nix
    ./misc.nix
    ./network.nix

    ../../modules/nixos/core
    ../../modules/nixos/fhs.nix
    ../../modules/nixos/extraServices
  ];

  custom.service.desktop.enable = true;
  custom.service.gaming.enable = true;
  custom.service.virtualization = {
    enable = true;
    docker = true;
    libvirtd = true;
  };
  custom.service.agenix.enable = true;
  # custom.service.desktop.power.type = "workstation";
}
