# Core NixOS profile shared by every managed host.
{ lib, ... }:

{
  imports = [
    ./boot.nix
    ./fonts.nix
    ./i18n.nix
    ./nix.nix
    ./packages.nix
    ./diagnostics.nix
    ./power.nix
    ./security.nix
    ./ssh.nix
    ./system.nix
    ./tailscale.nix
    ./kernel.nix
  ];

  custom.core.tailscale.enable = lib.mkDefault true;

  system.stateVersion = "25.11"; # Did you read the comment?
}
