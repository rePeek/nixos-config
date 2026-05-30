{
  imports = [
    ../hardware

    ./boot.nix
    ./fonts.nix
    ./i18n.nix
    ./nix.nix
    ./packages.nix
    ./ssh.nix
    ./system.nix
  ];

  system.stateVersion = "25.11"; # Did you read the comment?
}
