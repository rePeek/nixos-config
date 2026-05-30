{
  networking.hostName = "brain-holder";

  imports = [
    ./hardware

    ./user.nix
    ./misc.nix
    ./network.nix

    ../../modules/nixos
  ];

  custom.service.desktop.enable = true;
  custom.service.audio.enable = true;
  custom.desktop.bluetooth.enable = true;
  custom.desktop.network.enable = true;
  custom.service.fhs.enable = true;
  custom.service.gaming.enable = true;
  custom.service.power.profile = "performance";
  custom.service.virtualization = {
    enable = true;
    docker = true;
    libvirtd = true;
  };
  custom.service.agenix.enable = true;
  custom.tools.audio.enable = true;
  custom.tools.network.enable = true;
}
