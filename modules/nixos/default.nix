{
  imports = [
    # ./extraServices
    ./pkgs.nix
    ./nix.nix
    ./ssh.nix
    ./i18n.nix
    ./misc.nix
    ./boot.nix
  ];

  system.stateVersion = "25.11"; # Did you read the comment?
}
