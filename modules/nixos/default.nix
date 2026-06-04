{
  imports = [
    ./boot.nix
    ./fonts.nix
    ./i18n.nix
    ./nix.nix
    ./packages.nix
    ./security.nix
    ./ssh.nix
    ./system.nix

    ./features
    ./desktop
    ./service
    ./tools.nix
  ];

  system.stateVersion = "25.11"; # Did you read the comment?
}
