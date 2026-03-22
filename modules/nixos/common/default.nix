{ ... }:
{
  imports = [
    ./pkgs
    ./extraServices
    ./nix.nix
    ./pipewire.nix
    ./program.nix
    ./security.nix
    ./services.nix
    ./ssh.nix
    ./wayland.nix
    ./xserver.nix
    ./fonts.nix
    ./i18n.nix
  ];
}
