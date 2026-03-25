{
  imports = [
    ../../modules/nixos
    ./hardware
    ./user.nix
    ./misc.nix
    ./network.nix
  ];

  modules.desktop.gaming.enable = true;
  modules.network.daed.enable = true;
  # modules.powerManagement.type = "workstation";

  system.stateVersion = "25.11"; # Did you read the comment?
}
